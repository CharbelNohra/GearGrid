"use client"

import React, { useState } from "react"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import {
  FiUser,
  FiEdit2,
  FiX,
  FiCamera,
  FiMapPin,
  FiGlobe,
  FiPhone,
  FiLock,
  FiEye,
  FiEyeOff,
} from "react-icons/fi"
import { CiMail } from "react-icons/ci"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { countryPhoneData } from "@/constants/countries"

const Profile = () => {
  const [user, setUser] = useState({
    id: "USR12345",
    fullname: "John Doe",
    email: "john@example.com",
    address: "123 Main St",
    country: "Lebanon",
    countryCode: "+961",
    phone: "98765432",
    password: "123456",
    avatar: "https://github.com/shadcn.png",
  })

  const [formData, setFormData] = useState({
    ...user,
    oldPassword: "",
    newPassword: "",
  })

  const [isEditing, setIsEditing] = useState(false)
  const [avatarPreview, setAvatarPreview] = useState(user.avatar)
  const [showOldPassword, setShowOldPassword] = useState(false)
  const [showNewPassword, setShowNewPassword] = useState(false)

  // Selected country info
  const selectedCountry = countryPhoneData[formData.country]

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement> | string
  ) => {
    if (typeof e === "string") {
      // country selected
      const country = countryPhoneData[e]
      if (country) {
        setFormData((prev) => ({
          ...prev,
          country: e,
          countryCode: country.code,
          phone: "",
        }))
      }
    } else {
      const { name, value } = e.target

      if (name === "phone") {
        if (selectedCountry) {
          const digitsOnly = value.replace(/\D/g, "")
          const truncated = digitsOnly.slice(0, selectedCountry.length)
          setFormData((prev) => ({ ...prev, phone: truncated }))
        } else {
          setFormData((prev) => ({ ...prev, phone: value.replace(/\D/g, "") }))
        }
      } else {
        setFormData((prev) => ({ ...prev, [name]: value }))
      }
    }
  }

  const handleEdit = () => setIsEditing(true)

  const handleCancel = () => {
    setFormData({ ...user, oldPassword: "", newPassword: "" })
    setAvatarPreview(user.avatar)
    setIsEditing(false)
    setShowOldPassword(false)
    setShowNewPassword(false)
  }

  const handleAvatarChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      const file = e.target.files[0]
      const previewUrl = URL.createObjectURL(file)
      setAvatarPreview(previewUrl)
    }
  }

  const handleUpdate = () => {
    const hasChanges =
      formData.fullname !== user.fullname ||
      formData.email !== user.email ||
      formData.address !== user.address ||
      formData.country !== user.country ||
      formData.countryCode !== user.countryCode ||
      formData.phone !== user.phone ||
      avatarPreview !== user.avatar ||
      formData.newPassword

    if (!hasChanges) {
      console.log("No changes made")
      setFormData((prev) => ({ ...prev, oldPassword: "", newPassword: "" }))
      setShowOldPassword(false)
      setShowNewPassword(false)
      return
    }

    if (formData.oldPassword || formData.newPassword) {
      if (formData.oldPassword !== user.password) {
        alert("Old password is incorrect.")
        setFormData((prev) => ({ ...prev, oldPassword: "", newPassword: "" }))
        setShowOldPassword(false)
        setShowNewPassword(false)
        return
      }
      if (!formData.newPassword) {
        alert("Please enter a new password.")
        setFormData((prev) => ({ ...prev, oldPassword: "", newPassword: "" }))
        setShowOldPassword(false)
        setShowNewPassword(false)
        return
      }
    }

    if (selectedCountry && formData.phone.length !== selectedCountry.length) {
      alert(`Phone number must be exactly ${selectedCountry.length} digits.`)
      return
    }

    const updatedUser = {
      ...formData,
      password: formData.newPassword ? formData.newPassword : user.password,
      avatar: avatarPreview,
    }

    setUser(updatedUser)
    setFormData({ ...updatedUser, oldPassword: "", newPassword: "" })
    setIsEditing(false)
    setShowOldPassword(false)
    setShowNewPassword(false)

    console.log("Updated user data:", updatedUser)
  }

  return (
    <div className="flex flex-col items-center mt-20">
      {/* Avatar + User ID */}
      <div className="flex flex-col items-center gap-4 relative">
        <div className="relative">
          <Avatar className="w-24 h-24 cursor-pointer">
            <AvatarImage src={avatarPreview} alt="User avatar" />
            <AvatarFallback>U</AvatarFallback>
          </Avatar>

          {isEditing && (
            <>
              <label
                htmlFor="avatar-upload"
                className="absolute bottom-0 right-0 bg-primary text-primary-foreground rounded-full p-2 cursor-pointer shadow-md"
              >
                <FiCamera className="w-4 h-4" />
              </label>
              <input
                id="avatar-upload"
                type="file"
                accept="image/*"
                className="hidden"
                onChange={handleAvatarChange}
              />
            </>
          )}
        </div>

        <div className="text-center">
          <h3 className="text-lg font-semibold">User ID: {user.id}</h3>
        </div>
      </div>

      {/* Form */}
      <div className="flex flex-col items-center mt-10">
        <form className="flex flex-col gap-4 w-[22rem]">
          <Input
            type="text"
            name="fullname"
            placeholder="Full Name"
            value={formData.fullname}
            onChange={handleChange}
            disabled={!isEditing}
            prefix={<FiUser className="h-5 w-5 text-muted-foreground" />}
          />

          <Input
            type="email"
            name="email"
            placeholder="Email"
            value={formData.email}
            onChange={handleChange}
            disabled={!isEditing}
            prefix={<CiMail className="h-5 w-5 text-muted-foreground" />}
          />

          <div className="flex gap-2">
            <Input
              type="text"
              name="address"
              placeholder="Address"
              value={formData.address}
              onChange={handleChange}
              disabled={!isEditing}
              prefix={<FiMapPin className="h-4 w-4 text-muted-foreground" />}
            />

            <Select
              value={formData.country}
              onValueChange={handleChange}
              disabled={!isEditing}
            >
              <SelectTrigger className="flex-1">
                <SelectValue placeholder="Select country" />
              </SelectTrigger>
              <SelectContent>
                {Object.keys(countryPhoneData).map((country) => (
                  <SelectItem key={country} value={country}>
                    {country}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div className="flex gap-2 items-center">
            <Input
              type="text"
              name="countryCode"
              placeholder="Code"
              value={formData.countryCode}
              disabled
              prefix={<FiGlobe className="h-4 w-4 text-muted-foreground" />}
            />
            <div className="relative w-full">
              <Input
                type="tel"
                name="phone"
                placeholder="Phone Number"
                value={formData.phone}
                onChange={handleChange}
                disabled={!isEditing}
                prefix={<FiPhone className="h-4 w-4 text-muted-foreground" />}
              />
              <span className="absolute right-2 top-1/2 -translate-y-1/2 text-sm text-muted-foreground">
                {formData.phone.length}/{selectedCountry?.length || 0}
              </span>
            </div>
          </div>

          {/* Password fields */}
          <div className="flex gap-2">
            <Input
              type={showOldPassword ? "text" : "password"}
              name="oldPassword"
              placeholder="Old Password"
              value={formData.oldPassword}
              onChange={handleChange}
              disabled={!isEditing}
              prefix={<FiLock className="h-4 w-4 text-muted-foreground" />}
              suffix={
                <button
                  type="button"
                  onClick={() => setShowOldPassword((prev) => !prev)}
                  className="flex items-center"
                >
                  {showOldPassword ? <FiEyeOff /> : <FiEye />}
                </button>
              }
            />

            <Input
              type={showNewPassword ? "text" : "password"}
              name="newPassword"
              placeholder="New Password"
              value={formData.newPassword}
              onChange={handleChange}
              disabled={!isEditing}
              prefix={<FiLock className="h-4 w-4 text-muted-foreground" />}
              suffix={
                <button
                  type="button"
                  onClick={() => setShowNewPassword((prev) => !prev)}
                  className="flex items-center"
                >
                  {showNewPassword ? <FiEyeOff /> : <FiEye />}
                </button>
              }
            />
          </div>

          <div className="flex justify-between mt-4">
            {!isEditing ? (
              <Button variant="outline" onClick={handleEdit} type="button">
                <FiEdit2 className="mr-2" /> Edit
              </Button>
            ) : (
              <>
                <Button variant="outline" onClick={handleCancel} type="button">
                  <FiX className="mr-2" /> Cancel
                </Button>
                <Button onClick={handleUpdate} type="button">
                  Update
                </Button>
              </>
            )}
          </div>
        </form>
      </div>
    </div>
  )
}

export default Profile