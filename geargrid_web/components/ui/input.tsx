import * as React from "react"
import { cn } from "@/lib/utils"

interface InputProps
  extends Omit<React.InputHTMLAttributes<HTMLInputElement>, "prefix" | "suffix"> {
  prefix?: React.ReactNode
  suffix?: React.ReactNode
}

function Input({ className, type, prefix, suffix, ...props }: InputProps) {
  return (
    <div
      className={cn(
        "flex items-center w-full min-w-0 rounded-full border border-input bg-transparent shadow-xs transition-[color,box-shadow]",
        "focus-within:border-ring focus-within:ring-ring/50 focus-within:ring-[3px]",
        "aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive",
        className
      )}
    >
      {prefix && (
        <div className="flex items-center pl-3 text-muted-foreground">
          {prefix}
        </div>
      )}

      <input
        type={type}
        data-slot="input"
        className={cn(
          "flex-1 h-10 bg-transparent text-base md:text-sm outline-none",
          "file:text-foreground file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium",
          "placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground",
          "disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50",
          prefix ? "pl-3" : "px-3", // padding-left if prefix exists
          suffix ? "pr-3" : "px-3"  // padding-right if suffix exists
        )}
        {...props}
      />

      {suffix && (
        <div className="flex items-center pr-3 text-muted-foreground">
          {suffix}
        </div>
      )}
    </div>
  )
}

export { Input }
