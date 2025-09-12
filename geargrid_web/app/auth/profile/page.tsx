/* eslint-disable @typescript-eslint/no-unused-vars */
"use client"

import React, { useState, useEffect } from "react"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { FiUser, FiEdit2, FiX, FiCamera, FiMapPin, FiGlobe, FiPhone, FiLock, FiEye, FiEyeOff } from "react-icons/fi"
import { CiMail } from "react-icons/ci"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { countryPhoneData } from "@/constants/countries"
import { UpdateProfileData } from "@/services/authService"
import { getProfile, updateProfile } from "@/lib/auth"
import { useAuth } from "@/context/AuthContext"

interface ProfileFormData {
  fullName: string
  email: string
  address: string
  country: string
  countryCode: string
  phone: string
  oldPassword: string
  newPassword: string
  avatar?: string
}

const Profile = () => {
  const { user, setUser } = useAuth()
  const [formData, setFormData] = useState<ProfileFormData>({
    fullName: "",
    email: "",
    address: "",
    country: "",
    countryCode: "",
    phone: "",
    oldPassword: "",
    newPassword: "",
    avatar: "",
  })
  const [isEditing, setIsEditing] = useState(false)
  const [avatarFile, setAvatarFile] = useState<File | null>(null)
  const [avatarPreview, setAvatarPreview] = useState("")
  const [showOldPassword, setShowOldPassword] = useState(false)
  const [showNewPassword, setShowNewPassword] = useState(false)
  const [isLoading, setIsLoading] = useState(false)

  // Parse phone number into country, code, and local number
  const parsePhone = (phoneNumber?: string) => {
    if (!phoneNumber) return { country: "", countryCode: "", phone: "" }
    const found = Object.entries(countryPhoneData).find(([_, data]) =>
      phoneNumber.startsWith(data.code)
    )
    if (found) {
      const country = found[0]
      const countryCode = found[1].code
      const phone = phoneNumber.replace(countryCode, "")
      return { country, countryCode, phone }
    }
    return { country: "", countryCode: "", phone: phoneNumber }
  }

  // Fetch user profile on mount
  useEffect(() => {
    const fetchUser = async () => {
      try {
        const currentUser = await getProfile()
        setUser(currentUser)
        const { country, countryCode, phone } = parsePhone(currentUser.phoneNumber)
        setFormData({
          fullName: currentUser.fullName || "",
          email: currentUser.email || "",
          address: currentUser.address || "",
          country: country || currentUser.country || "",
          countryCode: countryCode,
          phone: phone,
          oldPassword: "",
          newPassword: "",
          avatar: currentUser.avatar || "",
        })
        setAvatarPreview(currentUser.avatar || "")
      } catch (err) {
        console.error(err)
      }
    }
    fetchUser()
  }, [setUser])

  const selectedCountry = countryPhoneData[formData.country]

  // Input change handler
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target
    if (name === "phone") {
      const digitsOnly = value.replace(/\D/g, "")
      const maxLength = selectedCountry?.length || digitsOnly.length
      setFormData((prev) => ({ ...prev, phone: digitsOnly.slice(0, maxLength) }))
    } else {
      setFormData((prev) => ({ ...prev, [name]: value }))
    }
  }

  const handleSelectChange = (country: string) => {
    const countryData = countryPhoneData[country]
    if (countryData) {
      setFormData((prev) => ({
        ...prev,
        country,
        countryCode: countryData.code,
        phone: "",
      }))
    }
  }

  const handleEdit = () => setIsEditing(true)

  const handleCancel = () => {
    if (user) {
      const { country, countryCode, phone } = parsePhone(user.phoneNumber)
      setFormData({
        fullName: user.fullName || "",
        email: user.email || "",
        address: user.address || "",
        country: country || user.country || "",
        countryCode: countryCode,
        phone: phone,
        oldPassword: "",
        newPassword: "",
        avatar: user.avatar || "",
      })
      setAvatarPreview(user.avatar || "")
      setAvatarFile(null)
    }
    setIsEditing(false)
    setShowOldPassword(false)
    setShowNewPassword(false)
  }

  const handleAvatarChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      const file = e.target.files[0]
      setAvatarFile(file)
      setAvatarPreview(URL.createObjectURL(file))
    }
  }

  const handleUpdate = async () => {
    if (!user) return

    const newPhone = formData.countryCode + formData.phone
    const hasChanges =
      formData.fullName !== (user.fullName || "") ||
      formData.email !== (user.email || "") ||
      formData.address !== (user.address || "") ||
      formData.country !== (user.country || "") ||
      newPhone !== (user.phoneNumber || "") ||
      avatarFile !== null ||
      formData.newPassword.trim() !== ""

    if (!hasChanges) {
      handleCancel()
      return
    }

    if (selectedCountry && formData.phone.length !== selectedCountry.length) {
      alert(`Phone number must be exactly ${selectedCountry.length} digits.`)
      return
    }

    if ((formData.oldPassword || formData.newPassword) && !formData.oldPassword) {
      alert("Please enter your current password to change it.")
      return
    }

    if (formData.newPassword && formData.newPassword.length < 6) {
      alert("New password must be at least 6 characters long.")
      return
    }

    setIsLoading(true)
    try {
      const updateData: UpdateProfileData = {
        fullName: formData.fullName,
        email: formData.email,
        country: formData.country,
        address: formData.address,
        phoneNumber: newPhone,
      }

      if (formData.newPassword.trim()) {
        updateData.password = formData.newPassword
      }

      await updateProfile(updateData, avatarFile || undefined)

      const freshUser = await getProfile()
      setUser(freshUser)
      const { country, countryCode, phone } = parsePhone(freshUser.phoneNumber)
      setFormData({
        fullName: freshUser.fullName || "",
        email: freshUser.email || "",
        address: freshUser.address || "",
        country: country || freshUser.country || "",
        countryCode: countryCode,
        phone: phone,
        oldPassword: "",
        newPassword: "",
        avatar: freshUser.avatar || "",
      })
      setAvatarPreview(freshUser.avatar || "")
      setAvatarFile(null)
      setIsEditing(false)
      setShowOldPassword(false)
      setShowNewPassword(false)

      alert("Profile updated successfully!")
    } catch (error) {
      console.error(error)
      alert(error instanceof Error ? error.message : "Failed to update profile.")
    } finally {
      setIsLoading(false)
    }
  }

  if (!user) return <div className="flex justify-center items-center mt-20">Loading...</div>

  return (
    <div className="flex flex-col items-center mt-20">
      <div className="flex flex-col items-center gap-4 relative">
        <div className="relative">
          <Avatar className="w-24 h-24 cursor-pointer border-1 border-secondary">
            <AvatarImage src={avatarPreview} alt="User avatar" />
            <AvatarFallback>{formData.fullName.charAt(0) || 'U'}</AvatarFallback>
          </Avatar>
          {isEditing && (
            <>
              <label htmlFor="avatar-upload" className="absolute bottom-0 right-0 bg-primary text-primary-foreground rounded-full p-2 cursor-pointer shadow-md">
                <FiCamera className="w-4 h-4" />
              </label>
              <input id="avatar-upload" type="file" accept="image/*" className="hidden" onChange={handleAvatarChange} />
            </>
          )}
        </div>
        <div className="text-center">
          <h3 className="text-lg font-semibold">User ID: {user.id}</h3>
        </div>
      </div>

      <div className="flex flex-col items-center mt-10">
        <form className="flex flex-col gap-4 w-[22rem]" onSubmit={(e) => e.preventDefault()}>
          <Input type="text" name="fullName" placeholder="Full Name" value={formData.fullName} onChange={handleInputChange} disabled={!isEditing} prefix={<FiUser className="h-5 w-5 text-muted-foreground" />} />
          <Input type="email" name="email" placeholder="Email" value={formData.email} onChange={handleInputChange} disabled={!isEditing} prefix={<CiMail className="h-5 w-5 text-muted-foreground" />} />
          
          <div className="flex gap-2">
            <Input type="text" name="address" placeholder="Address" value={formData.address} onChange={handleInputChange} disabled={!isEditing} prefix={<FiMapPin className="h-4 w-4 text-muted-foreground" />} />
            <Select value={formData.country} onValueChange={handleSelectChange} disabled={!isEditing}>
              <SelectTrigger className="flex-1">
                <SelectValue placeholder="Select country" />
              </SelectTrigger>
              <SelectContent>
                {Object.keys(countryPhoneData).map((country) => (
                  <SelectItem key={country} value={country}>{country}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div className="flex gap-2 items-center">
            <Input type="text" name="countryCode" placeholder="Code" value={formData.countryCode} disabled prefix={<FiGlobe className="h-4 w-4 text-muted-foreground" />} />
            <div className="relative w-full">
              <Input type="tel" name="phone" placeholder="Phone Number" value={formData.phone} onChange={handleInputChange} disabled={!isEditing} prefix={<FiPhone className="h-4 w-4 text-muted-foreground" />} />
              <span className="absolute right-2 top-1/2 -translate-y-1/2 text-sm text-muted-foreground">{formData.phone.length}/{selectedCountry?.length || 0}</span>
            </div>
          </div>

          {isEditing && (
            <div className="flex gap-2">
              <Input type={showOldPassword ? "text" : "password"} name="oldPassword" placeholder="Current Password" value={formData.oldPassword} onChange={handleInputChange} prefix={<FiLock className="h-4 w-4 text-muted-foreground" />} suffix={<button type="button" onClick={() => setShowOldPassword((prev) => !prev)} className="flex items-center">{showOldPassword ? <FiEyeOff /> : <FiEye />}</button>} />
              
              <Input type={showNewPassword ? "text" : "password"} name="newPassword" placeholder="New Password" value={formData.newPassword} onChange={handleInputChange} prefix={<FiLock className="h-4 w-4 text-muted-foreground" />} suffix={<button type="button" onClick={() => setShowNewPassword((prev) => !prev)} className="flex items-center">{showNewPassword ? <FiEyeOff /> : <FiEye />}</button>} />
            </div>
          )}

          <div className="flex justify-between mt-4">
            {!isEditing ? (
              <Button variant="outline" onClick={handleEdit} type="button"><FiEdit2 className="mr-2" /> Edit</Button>
            ) : (
              <>
                <Button variant="outline" onClick={handleCancel} type="button" disabled={isLoading}><FiX className="mr-2" /> Cancel</Button>
                <Button onClick={handleUpdate} type="button" disabled={isLoading}>{isLoading ? "Updating..." : "Update"}</Button>
              </>
            )}
          </div>
        </form>
      </div>
    </div>
  )
}

export default Profile