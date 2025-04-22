'use client'

import React from 'react'
import Input from '../components/Input'
import TextArea from '../components/TextArea'
import Button from '../components/Button'

const Page = () => {
  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100 px-4">
      <div className="bg-white shadow-lg rounded-lg p-8 max-w-lg w-full">
        <h1 className="text-3xl font-bold text-center text-indigo-800">Contact Us</h1>
        <p className="text-lg text-center mt-2 text-indigo-800">
          If you have any questions, feel free to reach out!
        </p>
        <form className="mt-6 flex flex-col space-y-4">
          <Input type="text" placeholder="Name" onChange={() => { }} />
          <Input type="email" placeholder="Email" onChange={() => { }} />
          <Input type="text" placeholder="Subject" onChange={() => { }} />
          <TextArea placeholder="Message" />
          <Button text="Submit" className="bg-indigo-900 text-white py-2 px-4 rounded-lg hover:bg-indigo-950 transition duration-300 w-full" onClick={() => { }} />
        </form>
      </div>
    </div>
  )
}

export default Page;