import React from 'react'

const Footer = () => {
  return (
    <footer className="bg-accent text-foreground py-4">
      <div className="container mx-auto text-center">
        <p className="text-sm">
          &copy; {new Date().getFullYear()} Your Company Name. All rights reserved.
        </p>
        <p className="text-xs mt-2">
          Built with ❤️ using Next.Js and Tailwind CSS.
        </p>
      </div>
    </footer>
  )
}

export default Footer
