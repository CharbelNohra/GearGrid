export interface CountryPhoneData {
  code: string;
  length: number;
}

export const countryPhoneData: Record<string, CountryPhoneData> = {
  Argentina: {
    code: "+54",
    length: 10,
  },
  Australia: {
    code: "+61",
    length: 9,
  },
  Bahrain: {
    code: "+973",
    length: 8,
  },
  Brazil: {
    code: "+55",
    length: 11,
  },
  Canada: {
    code: "+1",
    length: 10,
  },
  Chile: {
    code: "+56",
    length: 9,
  },
  China: {
    code: "+86",
    length: 11,
  },
  Colombia: {
    code: "+57",
    length: 10,
  },
  Egypt: {
    code: "+20",
    length: 10,
  },
  France: {
    code: "+33",
    length: 9,
  },
  Germany: {
    code: "+49",
    length: 10, // 7–11 range
  },
  India: {
    code: "+91",
    length: 10,
  },
  Indonesia: {
    code: "+62",
    length: 10, // 9–11
  },
  Italy: {
    code: "+39",
    length: 9,
  },
  Japan: {
    code: "+81",
    length: 10,
  },
  Kuwait: {
    code: "+965",
    length: 8,
  },
  Lebanon: {
    code: "+961",
    length: 8,
  },
  Malaysia: {
    code: "+60",
    length: 9, // 8–9
  },
  Mexico: {
    code: "+52",
    length: 10,
  },
  Netherlands: {
    code: "+31",
    length: 9,
  },
  NewZealand: {
    code: "+64",
    length: 9,
  },
  Oman: {
    code: "+968",
    length: 8,
  },
  Peru: {
    code: "+51",
    length: 9,
  },
  Philippines: {
    code: "+63",
    length: 10,
  },
  Qatar: {
    code: "+974",
    length: 8,
  },
  Russia: {
    code: "+7",
    length: 10,
  },
  SaudiArabia: {
    code: "+966",
    length: 9,
  },
  Singapore: {
    code: "+65",
    length: 8,
  },
  SouthAfrica: {
    code: "+27",
    length: 9,
  },
  SouthKorea: {
    code: "+82",
    length: 9, // sometimes 10
  },
  Spain: {
    code: "+34",
    length: 9,
  },
  Sweden: {
    code: "+46",
    length: 9, // can vary 7–10
  },
  Switzerland: {
    code: "+41",
    length: 9,
  },
  Thailand: {
    code: "+66",
    length: 9,
  },
  Turkey: {
    code: "+90",
    length: 10,
  },
  Ukraine: {
    code: "+380",
    length: 9,
  },
  UnitedArabEmirates: {
    code: "+971",
    length: 9,
  },
  UnitedKingdom: {
    code: "+44",
    length: 10, // sometimes 9
  },
  UnitedStates: {
    code: "+1",
    length: 10,
  },
  Vietnam: {
    code: "+84",
    length: 9, // mobiles 9–10
  },
};