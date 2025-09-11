import * as React from "react"
import { cn } from "@/lib/utils"

interface InputProps
  extends Omit<React.InputHTMLAttributes<HTMLInputElement>, "prefix" | "suffix"> {
  prefix?: React.ReactNode
  suffix?: React.ReactNode
}

function Input({ className, type, prefix, suffix, ...props }: InputProps) {
  return (
    <div className={cn("relative w-full min-w-0", className)}>
      {prefix && (
        <div className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground">
          {prefix}
        </div>
      )}

      <input
        type={type}
        className={cn(
          "w-full h-10 rounded-full border border-input bg-transparent text-base md:text-sm outline-none",
          prefix ? "pl-10" : "pl-3",
          suffix ? "pr-10" : "pr-3",
          "placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground",
          "disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50"
        )}
        {...props}
      />

      {suffix && (
        <div className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground">
          {suffix}
        </div>
      )}
    </div>
  )
}

export { Input }