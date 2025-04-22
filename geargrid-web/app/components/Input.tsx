'use client';

import React from 'react';

type InputProps = {
    type?: string;
    placeholder?: string;
    onChange?: React.ChangeEventHandler<HTMLInputElement>;
    value?: string | number | readonly string[];
};

const Input: React.FC<InputProps> = ({ type = 'text', placeholder, onChange, value }) => {
    return (
        <input
            className="input validator bg-indigo-900 text-white text-lg p-2 rounded-md w-full"
            type={type}
            placeholder={placeholder}
            onChange={onChange}
            value={value}
            required
        />
    );
};

export default Input;
