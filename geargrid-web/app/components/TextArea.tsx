'use client'

import React from 'react'

type TextAreaProps = {
    placeholder?: string;
    onChange?: React.ChangeEventHandler<HTMLTextAreaElement>;
    value?: string | number | readonly string[];
};

const TextArea: React.FC<TextAreaProps> = ({...props}) => {
  return (
    <textarea  
        className="textarea bg-indigo-900 text-white text-lg p-2 rounded-md w-full" 
        rows={4}
        onChange={props.onChange}
        value={props.value}
        placeholder={props.placeholder}>
    </textarea>
  )
}

export default TextArea
