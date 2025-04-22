import React from 'react';

type ButtonProps = {
  className?: string;
  onClick?: () => void;
  text: string;
};

const Button: React.FC<ButtonProps> = ({ className = '', onClick, text }) => {
  return (
    <button 
      className={`btn ${className}`}
      onClick={onClick}
    >
      {text}
    </button>
  );
};

export default Button;
