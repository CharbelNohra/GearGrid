import Link from 'next/link'
import Image from 'next/image'

const Header = () => {
  return (
    <div>
        <nav className='flex justify-between items-center bg-accent p-4 text-foreground'>
            <div className='text-lg font-bold'>
                <Link href="/" className='flex items-center'>
                  <Image src="/GearGrid.svg" alt="Logo" width={150} height={40} className='inline-block mr-2' />
                </Link>
            </div>
            <ul className='flex space-x-4'>
                <li><Link href="/">Home</Link></li>
                <li><Link href="/about">About</Link></li>
                <li><Link href="/contact">Contact</Link></li>
            </ul>
        </nav>
    </div>
  )
}

export default Header