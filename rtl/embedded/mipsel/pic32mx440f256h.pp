unit pic32mx440f256h;
interface
{$goto on}
{$modeswitch advancedrecords}
{$L startup.o}
{$PACKRECORDS 2}
type
  TBits_1 = 0..1;
  TBits_2 = 0..3;
  TBits_3 = 0..7;
  TBits_4 = 0..15;
  TBits_5 = 0..31;
  TBits_6 = 0..63;
  TBits_7 = 0..127;
  TBits_8 = 0..255;
  TBits_9 = 0..511;
  TBits_10 = 0..1023;
  TBits_11 = 0..2047;
  TBits_12 = 0..4095;
  TBits_13 = 0..8191;
  TBits_14 = 0..16383;
  TBits_15 = 0..32767;
  TBits_16 = 0..65535;
  TBits_17 = 0..131071;
  TBits_18 = 0..262143;
  TBits_19 = 0..524287;
  TBits_20 = 0..1048575;
  TBits_21 = 0..2097151;
  TBits_22 = 0..4194303;
  TBits_23 = 0..8388607;
  TBits_24 = 0..16777215;
  TBits_25 = 0..33554431;
  TBits_26 = 0..67108863;
  TBits_27 = 0..134217727;
  TBits_28 = 0..268435455;
  TBits_29 = 0..536870911;
  TBits_30 = 0..1073741823;
  TBits_31 = 0..2147483647;
  TBits_32 = 0..4294967295;
  TWDT_WDTCON = record
  private
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSWDTPS : TBits_5; assembler; nostackframe; inline;
    function  getSWDTPS0 : TBits_1; assembler; nostackframe; inline;
    function  getSWDTPS1 : TBits_1; assembler; nostackframe; inline;
    function  getSWDTPS2 : TBits_1; assembler; nostackframe; inline;
    function  getSWDTPS3 : TBits_1; assembler; nostackframe; inline;
    function  getSWDTPS4 : TBits_1; assembler; nostackframe; inline;
    function  getWDTCLR : TBits_1; assembler; nostackframe; inline;
    function  getWDTPS : TBits_5; assembler; nostackframe; inline;
    function  getWDTPSTA : TBits_5; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSWDTPS(thebits : TBits_5); assembler; nostackframe; inline;
    procedure setSWDTPS0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSWDTPS1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSWDTPS2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSWDTPS3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSWDTPS4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWDTCLR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWDTPS(thebits : TBits_5); assembler; nostackframe; inline;
    procedure setWDTPSTA(thebits : TBits_5); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearON;
    procedure clearSWDTPS0;
    procedure clearSWDTPS1;
    procedure clearSWDTPS2;
    procedure clearSWDTPS3;
    procedure clearSWDTPS4;
    procedure clearWDTCLR;
    procedure setON;
    procedure setSWDTPS0;
    procedure setSWDTPS1;
    procedure setSWDTPS2;
    procedure setSWDTPS3;
    procedure setSWDTPS4;
    procedure setWDTCLR;
    property ON : TBits_1 read getON write setON;
    property SWDTPS : TBits_5 read getSWDTPS write setSWDTPS;
    property SWDTPS0 : TBits_1 read getSWDTPS0 write setSWDTPS0;
    property SWDTPS1 : TBits_1 read getSWDTPS1 write setSWDTPS1;
    property SWDTPS2 : TBits_1 read getSWDTPS2 write setSWDTPS2;
    property SWDTPS3 : TBits_1 read getSWDTPS3 write setSWDTPS3;
    property SWDTPS4 : TBits_1 read getSWDTPS4 write setSWDTPS4;
    property WDTCLR : TBits_1 read getWDTCLR write setWDTCLR;
    property WDTPS : TBits_5 read getWDTPS write setWDTPS;
    property WDTPSTA : TBits_5 read getWDTPSTA write setWDTPSTA;
    property w : TBits_32 read getw write setw;
  end;
type
  TWDTRegisters = record
    WDTCONbits : TWDT_WDTCON;
    WDTCON : longWord;
    WDTCONCLR : longWord;
    WDTCONSET : longWord;
    WDTCONINV : longWord;
  end;
  TRTCC_RTCCON = record
  private
    function  getCAL : TBits_10; assembler; nostackframe; inline;
    function  getHALFSEC : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getRTCCLKON : TBits_1; assembler; nostackframe; inline;
    function  getRTCOE : TBits_1; assembler; nostackframe; inline;
    function  getRTCSYNC : TBits_1; assembler; nostackframe; inline;
    function  getRTCWREN : TBits_1; assembler; nostackframe; inline;
    function  getRTSECSEL : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCAL(thebits : TBits_10); assembler; nostackframe; inline;
    procedure setHALFSEC(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRTCCLKON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRTCOE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRTCSYNC(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRTCWREN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRTSECSEL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearHALFSEC;
    procedure clearON;
    procedure clearRTCCLKON;
    procedure clearRTCOE;
    procedure clearRTCSYNC;
    procedure clearRTCWREN;
    procedure clearRTSECSEL;
    procedure clearSIDL;
    procedure setHALFSEC;
    procedure setON;
    procedure setRTCCLKON;
    procedure setRTCOE;
    procedure setRTCSYNC;
    procedure setRTCWREN;
    procedure setRTSECSEL;
    procedure setSIDL;
    property CAL : TBits_10 read getCAL write setCAL;
    property HALFSEC : TBits_1 read getHALFSEC write setHALFSEC;
    property ON : TBits_1 read getON write setON;
    property RTCCLKON : TBits_1 read getRTCCLKON write setRTCCLKON;
    property RTCOE : TBits_1 read getRTCOE write setRTCOE;
    property RTCSYNC : TBits_1 read getRTCSYNC write setRTCSYNC;
    property RTCWREN : TBits_1 read getRTCWREN write setRTCWREN;
    property RTSECSEL : TBits_1 read getRTSECSEL write setRTSECSEL;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
  TRTCC_RTCALRM = record
  private
    function  getALRMEN : TBits_1; assembler; nostackframe; inline;
    function  getALRMSYNC : TBits_1; assembler; nostackframe; inline;
    function  getAMASK : TBits_4; assembler; nostackframe; inline;
    function  getARPT : TBits_8; assembler; nostackframe; inline;
    function  getCHIME : TBits_1; assembler; nostackframe; inline;
    function  getPIV : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setALRMEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setALRMSYNC(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setAMASK(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setARPT(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setCHIME(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPIV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearALRMEN;
    procedure clearALRMSYNC;
    procedure clearCHIME;
    procedure clearPIV;
    procedure setALRMEN;
    procedure setALRMSYNC;
    procedure setCHIME;
    procedure setPIV;
    property ALRMEN : TBits_1 read getALRMEN write setALRMEN;
    property ALRMSYNC : TBits_1 read getALRMSYNC write setALRMSYNC;
    property AMASK : TBits_4 read getAMASK write setAMASK;
    property ARPT : TBits_8 read getARPT write setARPT;
    property CHIME : TBits_1 read getCHIME write setCHIME;
    property PIV : TBits_1 read getPIV write setPIV;
    property w : TBits_32 read getw write setw;
  end;
  TRTCC_RTCTIME = record
  private
    function  getHR01 : TBits_4; assembler; nostackframe; inline;
    function  getHR10 : TBits_4; assembler; nostackframe; inline;
    function  getMIN01 : TBits_4; assembler; nostackframe; inline;
    function  getMIN10 : TBits_4; assembler; nostackframe; inline;
    function  getSEC01 : TBits_4; assembler; nostackframe; inline;
    function  getSEC10 : TBits_4; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setHR01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setHR10(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setMIN01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setMIN10(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setSEC01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setSEC10(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    property HR01 : TBits_4 read getHR01 write setHR01;
    property HR10 : TBits_4 read getHR10 write setHR10;
    property MIN01 : TBits_4 read getMIN01 write setMIN01;
    property MIN10 : TBits_4 read getMIN10 write setMIN10;
    property SEC01 : TBits_4 read getSEC01 write setSEC01;
    property SEC10 : TBits_4 read getSEC10 write setSEC10;
    property w : TBits_32 read getw write setw;
  end;
  TRTCC_RTCDATE = record
  private
    function  getDAY01 : TBits_4; assembler; nostackframe; inline;
    function  getDAY10 : TBits_4; assembler; nostackframe; inline;
    function  getMONTH01 : TBits_4; assembler; nostackframe; inline;
    function  getMONTH10 : TBits_4; assembler; nostackframe; inline;
    function  getWDAY01 : TBits_4; assembler; nostackframe; inline;
    function  getYEAR01 : TBits_4; assembler; nostackframe; inline;
    function  getYEAR10 : TBits_4; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setDAY01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setDAY10(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setMONTH01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setMONTH10(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setWDAY01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setYEAR01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setYEAR10(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    property DAY01 : TBits_4 read getDAY01 write setDAY01;
    property DAY10 : TBits_4 read getDAY10 write setDAY10;
    property MONTH01 : TBits_4 read getMONTH01 write setMONTH01;
    property MONTH10 : TBits_4 read getMONTH10 write setMONTH10;
    property WDAY01 : TBits_4 read getWDAY01 write setWDAY01;
    property YEAR01 : TBits_4 read getYEAR01 write setYEAR01;
    property YEAR10 : TBits_4 read getYEAR10 write setYEAR10;
    property w : TBits_32 read getw write setw;
  end;
  TRTCC_ALRMTIME = record
  private
    function  getHR01 : TBits_4; assembler; nostackframe; inline;
    function  getHR10 : TBits_4; assembler; nostackframe; inline;
    function  getMIN01 : TBits_4; assembler; nostackframe; inline;
    function  getMIN10 : TBits_4; assembler; nostackframe; inline;
    function  getSEC01 : TBits_4; assembler; nostackframe; inline;
    function  getSEC10 : TBits_4; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setHR01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setHR10(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setMIN01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setMIN10(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setSEC01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setSEC10(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    property HR01 : TBits_4 read getHR01 write setHR01;
    property HR10 : TBits_4 read getHR10 write setHR10;
    property MIN01 : TBits_4 read getMIN01 write setMIN01;
    property MIN10 : TBits_4 read getMIN10 write setMIN10;
    property SEC01 : TBits_4 read getSEC01 write setSEC01;
    property SEC10 : TBits_4 read getSEC10 write setSEC10;
    property w : TBits_32 read getw write setw;
  end;
  TRTCC_ALRMDATE = record
  private
    function  getDAY01 : TBits_4; assembler; nostackframe; inline;
    function  getDAY10 : TBits_4; assembler; nostackframe; inline;
    function  getMONTH01 : TBits_4; assembler; nostackframe; inline;
    function  getMONTH10 : TBits_4; assembler; nostackframe; inline;
    function  getWDAY01 : TBits_4; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setDAY01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setDAY10(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setMONTH01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setMONTH10(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setWDAY01(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    property DAY01 : TBits_4 read getDAY01 write setDAY01;
    property DAY10 : TBits_4 read getDAY10 write setDAY10;
    property MONTH01 : TBits_4 read getMONTH01 write setMONTH01;
    property MONTH10 : TBits_4 read getMONTH10 write setMONTH10;
    property WDAY01 : TBits_4 read getWDAY01 write setWDAY01;
    property w : TBits_32 read getw write setw;
  end;
type
  TRTCCRegisters = record
    RTCCONbits : TRTCC_RTCCON;
    RTCCON : longWord;
    RTCCONCLR : longWord;
    RTCCONSET : longWord;
    RTCCONINV : longWord;
    RTCALRMbits : TRTCC_RTCALRM;
    RTCALRM : longWord;
    RTCALRMCLR : longWord;
    RTCALRMSET : longWord;
    RTCALRMINV : longWord;
    RTCTIMEbits : TRTCC_RTCTIME;
    RTCTIME : longWord;
    RTCTIMECLR : longWord;
    RTCTIMESET : longWord;
    RTCTIMEINV : longWord;
    RTCDATEbits : TRTCC_RTCDATE;
    RTCDATE : longWord;
    RTCDATECLR : longWord;
    RTCDATESET : longWord;
    RTCDATEINV : longWord;
    ALRMTIMEbits : TRTCC_ALRMTIME;
    ALRMTIME : longWord;
    ALRMTIMECLR : longWord;
    ALRMTIMESET : longWord;
    ALRMTIMEINV : longWord;
    ALRMDATEbits : TRTCC_ALRMDATE;
    ALRMDATE : longWord;
    ALRMDATECLR : longWord;
    ALRMDATESET : longWord;
    ALRMDATEINV : longWord;
  end;
  TTMR1_T1CON = record
  private
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS : TBits_2; assembler; nostackframe; inline;
    function  getTCKPS0 : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS1 : TBits_1; assembler; nostackframe; inline;
    function  getTCS : TBits_1; assembler; nostackframe; inline;
    function  getTGATE : TBits_1; assembler; nostackframe; inline;
    function  getTON : TBits_1; assembler; nostackframe; inline;
    function  getTSIDL : TBits_1; assembler; nostackframe; inline;
    function  getTSYNC : TBits_1; assembler; nostackframe; inline;
    function  getTWDIS : TBits_1; assembler; nostackframe; inline;
    function  getTWIP : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setTCKPS0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTGATE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTSYNC(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTWDIS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTWIP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearON;
    procedure clearSIDL;
    procedure clearTCKPS0;
    procedure clearTCKPS1;
    procedure clearTCS;
    procedure clearTGATE;
    procedure clearTON;
    procedure clearTSIDL;
    procedure clearTSYNC;
    procedure clearTWDIS;
    procedure clearTWIP;
    procedure setON;
    procedure setSIDL;
    procedure setTCKPS0;
    procedure setTCKPS1;
    procedure setTCS;
    procedure setTGATE;
    procedure setTON;
    procedure setTSIDL;
    procedure setTSYNC;
    procedure setTWDIS;
    procedure setTWIP;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property TCKPS : TBits_2 read getTCKPS write setTCKPS;
    property TCKPS0 : TBits_1 read getTCKPS0 write setTCKPS0;
    property TCKPS1 : TBits_1 read getTCKPS1 write setTCKPS1;
    property TCS : TBits_1 read getTCS write setTCS;
    property TGATE : TBits_1 read getTGATE write setTGATE;
    property TON : TBits_1 read getTON write setTON;
    property TSIDL : TBits_1 read getTSIDL write setTSIDL;
    property TSYNC : TBits_1 read getTSYNC write setTSYNC;
    property TWDIS : TBits_1 read getTWDIS write setTWDIS;
    property TWIP : TBits_1 read getTWIP write setTWIP;
    property w : TBits_32 read getw write setw;
  end;
type
  TTMR1Registers = record
    T1CONbits : TTMR1_T1CON;
    T1CON : longWord;
    T1CONCLR : longWord;
    T1CONSET : longWord;
    T1CONINV : longWord;
    TMR1 : longWord;
    TMR1CLR : longWord;
    TMR1SET : longWord;
    TMR1INV : longWord;
    PR1 : longWord;
    PR1CLR : longWord;
    PR1SET : longWord;
    PR1INV : longWord;
  end;
  TTMR23_T2CON = record
  private
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getT32 : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS : TBits_3; assembler; nostackframe; inline;
    function  getTCKPS0 : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS1 : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS2 : TBits_1; assembler; nostackframe; inline;
    function  getTCS : TBits_1; assembler; nostackframe; inline;
    function  getTGATE : TBits_1; assembler; nostackframe; inline;
    function  getTON : TBits_1; assembler; nostackframe; inline;
    function  getTSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setT32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setTCKPS0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTGATE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearON;
    procedure clearSIDL;
    procedure clearT32;
    procedure clearTCKPS0;
    procedure clearTCKPS1;
    procedure clearTCKPS2;
    procedure clearTCS;
    procedure clearTGATE;
    procedure clearTON;
    procedure clearTSIDL;
    procedure setON;
    procedure setSIDL;
    procedure setT32;
    procedure setTCKPS0;
    procedure setTCKPS1;
    procedure setTCKPS2;
    procedure setTCS;
    procedure setTGATE;
    procedure setTON;
    procedure setTSIDL;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property T32 : TBits_1 read getT32 write setT32;
    property TCKPS : TBits_3 read getTCKPS write setTCKPS;
    property TCKPS0 : TBits_1 read getTCKPS0 write setTCKPS0;
    property TCKPS1 : TBits_1 read getTCKPS1 write setTCKPS1;
    property TCKPS2 : TBits_1 read getTCKPS2 write setTCKPS2;
    property TCS : TBits_1 read getTCS write setTCS;
    property TGATE : TBits_1 read getTGATE write setTGATE;
    property TON : TBits_1 read getTON write setTON;
    property TSIDL : TBits_1 read getTSIDL write setTSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TTMR23Registers = record
    T2CONbits : TTMR23_T2CON;
    T2CON : longWord;
    T2CONCLR : longWord;
    T2CONSET : longWord;
    T2CONINV : longWord;
    TMR2 : longWord;
    TMR2CLR : longWord;
    TMR2SET : longWord;
    TMR2INV : longWord;
    PR2 : longWord;
    PR2CLR : longWord;
    PR2SET : longWord;
    PR2INV : longWord;
  end;
  TTMR3_T3CON = record
  private
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS : TBits_3; assembler; nostackframe; inline;
    function  getTCKPS0 : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS1 : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS2 : TBits_1; assembler; nostackframe; inline;
    function  getTCS : TBits_1; assembler; nostackframe; inline;
    function  getTGATE : TBits_1; assembler; nostackframe; inline;
    function  getTON : TBits_1; assembler; nostackframe; inline;
    function  getTSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setTCKPS0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTGATE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearON;
    procedure clearSIDL;
    procedure clearTCKPS0;
    procedure clearTCKPS1;
    procedure clearTCKPS2;
    procedure clearTCS;
    procedure clearTGATE;
    procedure clearTON;
    procedure clearTSIDL;
    procedure setON;
    procedure setSIDL;
    procedure setTCKPS0;
    procedure setTCKPS1;
    procedure setTCKPS2;
    procedure setTCS;
    procedure setTGATE;
    procedure setTON;
    procedure setTSIDL;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property TCKPS : TBits_3 read getTCKPS write setTCKPS;
    property TCKPS0 : TBits_1 read getTCKPS0 write setTCKPS0;
    property TCKPS1 : TBits_1 read getTCKPS1 write setTCKPS1;
    property TCKPS2 : TBits_1 read getTCKPS2 write setTCKPS2;
    property TCS : TBits_1 read getTCS write setTCS;
    property TGATE : TBits_1 read getTGATE write setTGATE;
    property TON : TBits_1 read getTON write setTON;
    property TSIDL : TBits_1 read getTSIDL write setTSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TTMR3Registers = record
    T3CONbits : TTMR3_T3CON;
    T3CON : longWord;
    T3CONCLR : longWord;
    T3CONSET : longWord;
    T3CONINV : longWord;
    TMR3 : longWord;
    TMR3CLR : longWord;
    TMR3SET : longWord;
    TMR3INV : longWord;
    PR3 : longWord;
    PR3CLR : longWord;
    PR3SET : longWord;
    PR3INV : longWord;
  end;
  TTMR4_T4CON = record
  private
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getT32 : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS : TBits_3; assembler; nostackframe; inline;
    function  getTCKPS0 : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS1 : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS2 : TBits_1; assembler; nostackframe; inline;
    function  getTCS : TBits_1; assembler; nostackframe; inline;
    function  getTGATE : TBits_1; assembler; nostackframe; inline;
    function  getTON : TBits_1; assembler; nostackframe; inline;
    function  getTSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setT32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setTCKPS0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTGATE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearON;
    procedure clearSIDL;
    procedure clearT32;
    procedure clearTCKPS0;
    procedure clearTCKPS1;
    procedure clearTCKPS2;
    procedure clearTCS;
    procedure clearTGATE;
    procedure clearTON;
    procedure clearTSIDL;
    procedure setON;
    procedure setSIDL;
    procedure setT32;
    procedure setTCKPS0;
    procedure setTCKPS1;
    procedure setTCKPS2;
    procedure setTCS;
    procedure setTGATE;
    procedure setTON;
    procedure setTSIDL;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property T32 : TBits_1 read getT32 write setT32;
    property TCKPS : TBits_3 read getTCKPS write setTCKPS;
    property TCKPS0 : TBits_1 read getTCKPS0 write setTCKPS0;
    property TCKPS1 : TBits_1 read getTCKPS1 write setTCKPS1;
    property TCKPS2 : TBits_1 read getTCKPS2 write setTCKPS2;
    property TCS : TBits_1 read getTCS write setTCS;
    property TGATE : TBits_1 read getTGATE write setTGATE;
    property TON : TBits_1 read getTON write setTON;
    property TSIDL : TBits_1 read getTSIDL write setTSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TTMR4Registers = record
    T4CONbits : TTMR4_T4CON;
    T4CON : longWord;
    T4CONCLR : longWord;
    T4CONSET : longWord;
    T4CONINV : longWord;
    TMR4 : longWord;
    TMR4CLR : longWord;
    TMR4SET : longWord;
    TMR4INV : longWord;
    PR4 : longWord;
    PR4CLR : longWord;
    PR4SET : longWord;
    PR4INV : longWord;
  end;
  TTMR5_T5CON = record
  private
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS : TBits_3; assembler; nostackframe; inline;
    function  getTCKPS0 : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS1 : TBits_1; assembler; nostackframe; inline;
    function  getTCKPS2 : TBits_1; assembler; nostackframe; inline;
    function  getTCS : TBits_1; assembler; nostackframe; inline;
    function  getTGATE : TBits_1; assembler; nostackframe; inline;
    function  getTON : TBits_1; assembler; nostackframe; inline;
    function  getTSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setTCKPS0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCKPS2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTCS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTGATE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearON;
    procedure clearSIDL;
    procedure clearTCKPS0;
    procedure clearTCKPS1;
    procedure clearTCKPS2;
    procedure clearTCS;
    procedure clearTGATE;
    procedure clearTON;
    procedure clearTSIDL;
    procedure setON;
    procedure setSIDL;
    procedure setTCKPS0;
    procedure setTCKPS1;
    procedure setTCKPS2;
    procedure setTCS;
    procedure setTGATE;
    procedure setTON;
    procedure setTSIDL;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property TCKPS : TBits_3 read getTCKPS write setTCKPS;
    property TCKPS0 : TBits_1 read getTCKPS0 write setTCKPS0;
    property TCKPS1 : TBits_1 read getTCKPS1 write setTCKPS1;
    property TCKPS2 : TBits_1 read getTCKPS2 write setTCKPS2;
    property TCS : TBits_1 read getTCS write setTCS;
    property TGATE : TBits_1 read getTGATE write setTGATE;
    property TON : TBits_1 read getTON write setTON;
    property TSIDL : TBits_1 read getTSIDL write setTSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TTMR5Registers = record
    T5CONbits : TTMR5_T5CON;
    T5CON : longWord;
    T5CONCLR : longWord;
    T5CONSET : longWord;
    T5CONINV : longWord;
    TMR5 : longWord;
    TMR5CLR : longWord;
    TMR5SET : longWord;
    TMR5INV : longWord;
    PR5 : longWord;
    PR5CLR : longWord;
    PR5SET : longWord;
    PR5INV : longWord;
  end;
  TICAP1_IC1CON = record
  private
    function  getC32 : TBits_1; assembler; nostackframe; inline;
    function  getFEDGE : TBits_1; assembler; nostackframe; inline;
    function  getICBNE : TBits_1; assembler; nostackframe; inline;
    function  getICI : TBits_2; assembler; nostackframe; inline;
    function  getICI0 : TBits_1; assembler; nostackframe; inline;
    function  getICI1 : TBits_1; assembler; nostackframe; inline;
    function  getICM : TBits_3; assembler; nostackframe; inline;
    function  getICM0 : TBits_1; assembler; nostackframe; inline;
    function  getICM1 : TBits_1; assembler; nostackframe; inline;
    function  getICM2 : TBits_1; assembler; nostackframe; inline;
    function  getICOV : TBits_1; assembler; nostackframe; inline;
    function  getICSIDL : TBits_1; assembler; nostackframe; inline;
    function  getICTMR : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setC32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFEDGE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICBNE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICI(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setICI0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICI1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setICM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICOV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICTMR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearC32;
    procedure clearFEDGE;
    procedure clearICBNE;
    procedure clearICI0;
    procedure clearICI1;
    procedure clearICM0;
    procedure clearICM1;
    procedure clearICM2;
    procedure clearICOV;
    procedure clearICSIDL;
    procedure clearICTMR;
    procedure clearON;
    procedure clearSIDL;
    procedure setC32;
    procedure setFEDGE;
    procedure setICBNE;
    procedure setICI0;
    procedure setICI1;
    procedure setICM0;
    procedure setICM1;
    procedure setICM2;
    procedure setICOV;
    procedure setICSIDL;
    procedure setICTMR;
    procedure setON;
    procedure setSIDL;
    property C32 : TBits_1 read getC32 write setC32;
    property FEDGE : TBits_1 read getFEDGE write setFEDGE;
    property ICBNE : TBits_1 read getICBNE write setICBNE;
    property ICI : TBits_2 read getICI write setICI;
    property ICI0 : TBits_1 read getICI0 write setICI0;
    property ICI1 : TBits_1 read getICI1 write setICI1;
    property ICM : TBits_3 read getICM write setICM;
    property ICM0 : TBits_1 read getICM0 write setICM0;
    property ICM1 : TBits_1 read getICM1 write setICM1;
    property ICM2 : TBits_1 read getICM2 write setICM2;
    property ICOV : TBits_1 read getICOV write setICOV;
    property ICSIDL : TBits_1 read getICSIDL write setICSIDL;
    property ICTMR : TBits_1 read getICTMR write setICTMR;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TICAP1Registers = record
    IC1CONbits : TICAP1_IC1CON;
    IC1CON : longWord;
    IC1CONCLR : longWord;
    IC1CONSET : longWord;
    IC1CONINV : longWord;
    IC1BUF : longWord;
  end;
  TICAP2_IC2CON = record
  private
    function  getC32 : TBits_1; assembler; nostackframe; inline;
    function  getFEDGE : TBits_1; assembler; nostackframe; inline;
    function  getICBNE : TBits_1; assembler; nostackframe; inline;
    function  getICI : TBits_2; assembler; nostackframe; inline;
    function  getICI0 : TBits_1; assembler; nostackframe; inline;
    function  getICI1 : TBits_1; assembler; nostackframe; inline;
    function  getICM : TBits_3; assembler; nostackframe; inline;
    function  getICM0 : TBits_1; assembler; nostackframe; inline;
    function  getICM1 : TBits_1; assembler; nostackframe; inline;
    function  getICM2 : TBits_1; assembler; nostackframe; inline;
    function  getICOV : TBits_1; assembler; nostackframe; inline;
    function  getICSIDL : TBits_1; assembler; nostackframe; inline;
    function  getICTMR : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setC32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFEDGE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICBNE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICI(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setICI0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICI1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setICM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICOV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICTMR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearC32;
    procedure clearFEDGE;
    procedure clearICBNE;
    procedure clearICI0;
    procedure clearICI1;
    procedure clearICM0;
    procedure clearICM1;
    procedure clearICM2;
    procedure clearICOV;
    procedure clearICSIDL;
    procedure clearICTMR;
    procedure clearON;
    procedure clearSIDL;
    procedure setC32;
    procedure setFEDGE;
    procedure setICBNE;
    procedure setICI0;
    procedure setICI1;
    procedure setICM0;
    procedure setICM1;
    procedure setICM2;
    procedure setICOV;
    procedure setICSIDL;
    procedure setICTMR;
    procedure setON;
    procedure setSIDL;
    property C32 : TBits_1 read getC32 write setC32;
    property FEDGE : TBits_1 read getFEDGE write setFEDGE;
    property ICBNE : TBits_1 read getICBNE write setICBNE;
    property ICI : TBits_2 read getICI write setICI;
    property ICI0 : TBits_1 read getICI0 write setICI0;
    property ICI1 : TBits_1 read getICI1 write setICI1;
    property ICM : TBits_3 read getICM write setICM;
    property ICM0 : TBits_1 read getICM0 write setICM0;
    property ICM1 : TBits_1 read getICM1 write setICM1;
    property ICM2 : TBits_1 read getICM2 write setICM2;
    property ICOV : TBits_1 read getICOV write setICOV;
    property ICSIDL : TBits_1 read getICSIDL write setICSIDL;
    property ICTMR : TBits_1 read getICTMR write setICTMR;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TICAP2Registers = record
    IC2CONbits : TICAP2_IC2CON;
    IC2CON : longWord;
    IC2CONCLR : longWord;
    IC2CONSET : longWord;
    IC2CONINV : longWord;
    IC2BUF : longWord;
  end;
  TICAP3_IC3CON = record
  private
    function  getC32 : TBits_1; assembler; nostackframe; inline;
    function  getFEDGE : TBits_1; assembler; nostackframe; inline;
    function  getICBNE : TBits_1; assembler; nostackframe; inline;
    function  getICI : TBits_2; assembler; nostackframe; inline;
    function  getICI0 : TBits_1; assembler; nostackframe; inline;
    function  getICI1 : TBits_1; assembler; nostackframe; inline;
    function  getICM : TBits_3; assembler; nostackframe; inline;
    function  getICM0 : TBits_1; assembler; nostackframe; inline;
    function  getICM1 : TBits_1; assembler; nostackframe; inline;
    function  getICM2 : TBits_1; assembler; nostackframe; inline;
    function  getICOV : TBits_1; assembler; nostackframe; inline;
    function  getICSIDL : TBits_1; assembler; nostackframe; inline;
    function  getICTMR : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setC32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFEDGE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICBNE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICI(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setICI0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICI1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setICM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICOV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICTMR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearC32;
    procedure clearFEDGE;
    procedure clearICBNE;
    procedure clearICI0;
    procedure clearICI1;
    procedure clearICM0;
    procedure clearICM1;
    procedure clearICM2;
    procedure clearICOV;
    procedure clearICSIDL;
    procedure clearICTMR;
    procedure clearON;
    procedure clearSIDL;
    procedure setC32;
    procedure setFEDGE;
    procedure setICBNE;
    procedure setICI0;
    procedure setICI1;
    procedure setICM0;
    procedure setICM1;
    procedure setICM2;
    procedure setICOV;
    procedure setICSIDL;
    procedure setICTMR;
    procedure setON;
    procedure setSIDL;
    property C32 : TBits_1 read getC32 write setC32;
    property FEDGE : TBits_1 read getFEDGE write setFEDGE;
    property ICBNE : TBits_1 read getICBNE write setICBNE;
    property ICI : TBits_2 read getICI write setICI;
    property ICI0 : TBits_1 read getICI0 write setICI0;
    property ICI1 : TBits_1 read getICI1 write setICI1;
    property ICM : TBits_3 read getICM write setICM;
    property ICM0 : TBits_1 read getICM0 write setICM0;
    property ICM1 : TBits_1 read getICM1 write setICM1;
    property ICM2 : TBits_1 read getICM2 write setICM2;
    property ICOV : TBits_1 read getICOV write setICOV;
    property ICSIDL : TBits_1 read getICSIDL write setICSIDL;
    property ICTMR : TBits_1 read getICTMR write setICTMR;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TICAP3Registers = record
    IC3CONbits : TICAP3_IC3CON;
    IC3CON : longWord;
    IC3CONCLR : longWord;
    IC3CONSET : longWord;
    IC3CONINV : longWord;
    IC3BUF : longWord;
  end;
  TICAP4_IC4CON = record
  private
    function  getC32 : TBits_1; assembler; nostackframe; inline;
    function  getFEDGE : TBits_1; assembler; nostackframe; inline;
    function  getICBNE : TBits_1; assembler; nostackframe; inline;
    function  getICI : TBits_2; assembler; nostackframe; inline;
    function  getICI0 : TBits_1; assembler; nostackframe; inline;
    function  getICI1 : TBits_1; assembler; nostackframe; inline;
    function  getICM : TBits_3; assembler; nostackframe; inline;
    function  getICM0 : TBits_1; assembler; nostackframe; inline;
    function  getICM1 : TBits_1; assembler; nostackframe; inline;
    function  getICM2 : TBits_1; assembler; nostackframe; inline;
    function  getICOV : TBits_1; assembler; nostackframe; inline;
    function  getICSIDL : TBits_1; assembler; nostackframe; inline;
    function  getICTMR : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setC32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFEDGE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICBNE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICI(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setICI0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICI1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setICM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICOV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICTMR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearC32;
    procedure clearFEDGE;
    procedure clearICBNE;
    procedure clearICI0;
    procedure clearICI1;
    procedure clearICM0;
    procedure clearICM1;
    procedure clearICM2;
    procedure clearICOV;
    procedure clearICSIDL;
    procedure clearICTMR;
    procedure clearON;
    procedure clearSIDL;
    procedure setC32;
    procedure setFEDGE;
    procedure setICBNE;
    procedure setICI0;
    procedure setICI1;
    procedure setICM0;
    procedure setICM1;
    procedure setICM2;
    procedure setICOV;
    procedure setICSIDL;
    procedure setICTMR;
    procedure setON;
    procedure setSIDL;
    property C32 : TBits_1 read getC32 write setC32;
    property FEDGE : TBits_1 read getFEDGE write setFEDGE;
    property ICBNE : TBits_1 read getICBNE write setICBNE;
    property ICI : TBits_2 read getICI write setICI;
    property ICI0 : TBits_1 read getICI0 write setICI0;
    property ICI1 : TBits_1 read getICI1 write setICI1;
    property ICM : TBits_3 read getICM write setICM;
    property ICM0 : TBits_1 read getICM0 write setICM0;
    property ICM1 : TBits_1 read getICM1 write setICM1;
    property ICM2 : TBits_1 read getICM2 write setICM2;
    property ICOV : TBits_1 read getICOV write setICOV;
    property ICSIDL : TBits_1 read getICSIDL write setICSIDL;
    property ICTMR : TBits_1 read getICTMR write setICTMR;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TICAP4Registers = record
    IC4CONbits : TICAP4_IC4CON;
    IC4CON : longWord;
    IC4CONCLR : longWord;
    IC4CONSET : longWord;
    IC4CONINV : longWord;
    IC4BUF : longWord;
  end;
  TICAP5_IC5CON = record
  private
    function  getC32 : TBits_1; assembler; nostackframe; inline;
    function  getFEDGE : TBits_1; assembler; nostackframe; inline;
    function  getICBNE : TBits_1; assembler; nostackframe; inline;
    function  getICI : TBits_2; assembler; nostackframe; inline;
    function  getICI0 : TBits_1; assembler; nostackframe; inline;
    function  getICI1 : TBits_1; assembler; nostackframe; inline;
    function  getICM : TBits_3; assembler; nostackframe; inline;
    function  getICM0 : TBits_1; assembler; nostackframe; inline;
    function  getICM1 : TBits_1; assembler; nostackframe; inline;
    function  getICM2 : TBits_1; assembler; nostackframe; inline;
    function  getICOV : TBits_1; assembler; nostackframe; inline;
    function  getICSIDL : TBits_1; assembler; nostackframe; inline;
    function  getICTMR : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setC32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFEDGE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICBNE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICI(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setICI0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICI1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setICM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICOV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setICTMR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearC32;
    procedure clearFEDGE;
    procedure clearICBNE;
    procedure clearICI0;
    procedure clearICI1;
    procedure clearICM0;
    procedure clearICM1;
    procedure clearICM2;
    procedure clearICOV;
    procedure clearICSIDL;
    procedure clearICTMR;
    procedure clearON;
    procedure clearSIDL;
    procedure setC32;
    procedure setFEDGE;
    procedure setICBNE;
    procedure setICI0;
    procedure setICI1;
    procedure setICM0;
    procedure setICM1;
    procedure setICM2;
    procedure setICOV;
    procedure setICSIDL;
    procedure setICTMR;
    procedure setON;
    procedure setSIDL;
    property C32 : TBits_1 read getC32 write setC32;
    property FEDGE : TBits_1 read getFEDGE write setFEDGE;
    property ICBNE : TBits_1 read getICBNE write setICBNE;
    property ICI : TBits_2 read getICI write setICI;
    property ICI0 : TBits_1 read getICI0 write setICI0;
    property ICI1 : TBits_1 read getICI1 write setICI1;
    property ICM : TBits_3 read getICM write setICM;
    property ICM0 : TBits_1 read getICM0 write setICM0;
    property ICM1 : TBits_1 read getICM1 write setICM1;
    property ICM2 : TBits_1 read getICM2 write setICM2;
    property ICOV : TBits_1 read getICOV write setICOV;
    property ICSIDL : TBits_1 read getICSIDL write setICSIDL;
    property ICTMR : TBits_1 read getICTMR write setICTMR;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TICAP5Registers = record
    IC5CONbits : TICAP5_IC5CON;
    IC5CON : longWord;
    IC5CONCLR : longWord;
    IC5CONSET : longWord;
    IC5CONINV : longWord;
    IC5BUF : longWord;
  end;
  TOCMP1_OC1CON = record
  private
    function  getOC32 : TBits_1; assembler; nostackframe; inline;
    function  getOCFLT : TBits_1; assembler; nostackframe; inline;
    function  getOCM : TBits_3; assembler; nostackframe; inline;
    function  getOCM0 : TBits_1; assembler; nostackframe; inline;
    function  getOCM1 : TBits_1; assembler; nostackframe; inline;
    function  getOCM2 : TBits_1; assembler; nostackframe; inline;
    function  getOCSIDL : TBits_1; assembler; nostackframe; inline;
    function  getOCTSEL : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setOC32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCFLT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setOCM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCTSEL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearOC32;
    procedure clearOCFLT;
    procedure clearOCM0;
    procedure clearOCM1;
    procedure clearOCM2;
    procedure clearOCSIDL;
    procedure clearOCTSEL;
    procedure clearON;
    procedure clearSIDL;
    procedure setOC32;
    procedure setOCFLT;
    procedure setOCM0;
    procedure setOCM1;
    procedure setOCM2;
    procedure setOCSIDL;
    procedure setOCTSEL;
    procedure setON;
    procedure setSIDL;
    property OC32 : TBits_1 read getOC32 write setOC32;
    property OCFLT : TBits_1 read getOCFLT write setOCFLT;
    property OCM : TBits_3 read getOCM write setOCM;
    property OCM0 : TBits_1 read getOCM0 write setOCM0;
    property OCM1 : TBits_1 read getOCM1 write setOCM1;
    property OCM2 : TBits_1 read getOCM2 write setOCM2;
    property OCSIDL : TBits_1 read getOCSIDL write setOCSIDL;
    property OCTSEL : TBits_1 read getOCTSEL write setOCTSEL;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TOCMP1Registers = record
    OC1CONbits : TOCMP1_OC1CON;
    OC1CON : longWord;
    OC1CONCLR : longWord;
    OC1CONSET : longWord;
    OC1CONINV : longWord;
    OC1R : longWord;
    OC1RCLR : longWord;
    OC1RSET : longWord;
    OC1RINV : longWord;
    OC1RS : longWord;
    OC1RSCLR : longWord;
    OC1RSSET : longWord;
    OC1RSINV : longWord;
  end;
  TOCMP2_OC2CON = record
  private
    function  getOC32 : TBits_1; assembler; nostackframe; inline;
    function  getOCFLT : TBits_1; assembler; nostackframe; inline;
    function  getOCM : TBits_3; assembler; nostackframe; inline;
    function  getOCM0 : TBits_1; assembler; nostackframe; inline;
    function  getOCM1 : TBits_1; assembler; nostackframe; inline;
    function  getOCM2 : TBits_1; assembler; nostackframe; inline;
    function  getOCSIDL : TBits_1; assembler; nostackframe; inline;
    function  getOCTSEL : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setOC32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCFLT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setOCM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCTSEL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearOC32;
    procedure clearOCFLT;
    procedure clearOCM0;
    procedure clearOCM1;
    procedure clearOCM2;
    procedure clearOCSIDL;
    procedure clearOCTSEL;
    procedure clearON;
    procedure clearSIDL;
    procedure setOC32;
    procedure setOCFLT;
    procedure setOCM0;
    procedure setOCM1;
    procedure setOCM2;
    procedure setOCSIDL;
    procedure setOCTSEL;
    procedure setON;
    procedure setSIDL;
    property OC32 : TBits_1 read getOC32 write setOC32;
    property OCFLT : TBits_1 read getOCFLT write setOCFLT;
    property OCM : TBits_3 read getOCM write setOCM;
    property OCM0 : TBits_1 read getOCM0 write setOCM0;
    property OCM1 : TBits_1 read getOCM1 write setOCM1;
    property OCM2 : TBits_1 read getOCM2 write setOCM2;
    property OCSIDL : TBits_1 read getOCSIDL write setOCSIDL;
    property OCTSEL : TBits_1 read getOCTSEL write setOCTSEL;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TOCMP2Registers = record
    OC2CONbits : TOCMP2_OC2CON;
    OC2CON : longWord;
    OC2CONCLR : longWord;
    OC2CONSET : longWord;
    OC2CONINV : longWord;
    OC2R : longWord;
    OC2RCLR : longWord;
    OC2RSET : longWord;
    OC2RINV : longWord;
    OC2RS : longWord;
    OC2RSCLR : longWord;
    OC2RSSET : longWord;
    OC2RSINV : longWord;
  end;
  TOCMP3_OC3CON = record
  private
    function  getOC32 : TBits_1; assembler; nostackframe; inline;
    function  getOCFLT : TBits_1; assembler; nostackframe; inline;
    function  getOCM : TBits_3; assembler; nostackframe; inline;
    function  getOCM0 : TBits_1; assembler; nostackframe; inline;
    function  getOCM1 : TBits_1; assembler; nostackframe; inline;
    function  getOCM2 : TBits_1; assembler; nostackframe; inline;
    function  getOCSIDL : TBits_1; assembler; nostackframe; inline;
    function  getOCTSEL : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setOC32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCFLT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setOCM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCTSEL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearOC32;
    procedure clearOCFLT;
    procedure clearOCM0;
    procedure clearOCM1;
    procedure clearOCM2;
    procedure clearOCSIDL;
    procedure clearOCTSEL;
    procedure clearON;
    procedure clearSIDL;
    procedure setOC32;
    procedure setOCFLT;
    procedure setOCM0;
    procedure setOCM1;
    procedure setOCM2;
    procedure setOCSIDL;
    procedure setOCTSEL;
    procedure setON;
    procedure setSIDL;
    property OC32 : TBits_1 read getOC32 write setOC32;
    property OCFLT : TBits_1 read getOCFLT write setOCFLT;
    property OCM : TBits_3 read getOCM write setOCM;
    property OCM0 : TBits_1 read getOCM0 write setOCM0;
    property OCM1 : TBits_1 read getOCM1 write setOCM1;
    property OCM2 : TBits_1 read getOCM2 write setOCM2;
    property OCSIDL : TBits_1 read getOCSIDL write setOCSIDL;
    property OCTSEL : TBits_1 read getOCTSEL write setOCTSEL;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TOCMP3Registers = record
    OC3CONbits : TOCMP3_OC3CON;
    OC3CON : longWord;
    OC3CONCLR : longWord;
    OC3CONSET : longWord;
    OC3CONINV : longWord;
    OC3R : longWord;
    OC3RCLR : longWord;
    OC3RSET : longWord;
    OC3RINV : longWord;
    OC3RS : longWord;
    OC3RSCLR : longWord;
    OC3RSSET : longWord;
    OC3RSINV : longWord;
  end;
  TOCMP4_OC4CON = record
  private
    function  getOC32 : TBits_1; assembler; nostackframe; inline;
    function  getOCFLT : TBits_1; assembler; nostackframe; inline;
    function  getOCM : TBits_3; assembler; nostackframe; inline;
    function  getOCM0 : TBits_1; assembler; nostackframe; inline;
    function  getOCM1 : TBits_1; assembler; nostackframe; inline;
    function  getOCM2 : TBits_1; assembler; nostackframe; inline;
    function  getOCSIDL : TBits_1; assembler; nostackframe; inline;
    function  getOCTSEL : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setOC32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCFLT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setOCM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCTSEL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearOC32;
    procedure clearOCFLT;
    procedure clearOCM0;
    procedure clearOCM1;
    procedure clearOCM2;
    procedure clearOCSIDL;
    procedure clearOCTSEL;
    procedure clearON;
    procedure clearSIDL;
    procedure setOC32;
    procedure setOCFLT;
    procedure setOCM0;
    procedure setOCM1;
    procedure setOCM2;
    procedure setOCSIDL;
    procedure setOCTSEL;
    procedure setON;
    procedure setSIDL;
    property OC32 : TBits_1 read getOC32 write setOC32;
    property OCFLT : TBits_1 read getOCFLT write setOCFLT;
    property OCM : TBits_3 read getOCM write setOCM;
    property OCM0 : TBits_1 read getOCM0 write setOCM0;
    property OCM1 : TBits_1 read getOCM1 write setOCM1;
    property OCM2 : TBits_1 read getOCM2 write setOCM2;
    property OCSIDL : TBits_1 read getOCSIDL write setOCSIDL;
    property OCTSEL : TBits_1 read getOCTSEL write setOCTSEL;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TOCMP4Registers = record
    OC4CONbits : TOCMP4_OC4CON;
    OC4CON : longWord;
    OC4CONCLR : longWord;
    OC4CONSET : longWord;
    OC4CONINV : longWord;
    OC4R : longWord;
    OC4RCLR : longWord;
    OC4RSET : longWord;
    OC4RINV : longWord;
    OC4RS : longWord;
    OC4RSCLR : longWord;
    OC4RSSET : longWord;
    OC4RSINV : longWord;
  end;
  TOCMP5_OC5CON = record
  private
    function  getOC32 : TBits_1; assembler; nostackframe; inline;
    function  getOCFLT : TBits_1; assembler; nostackframe; inline;
    function  getOCM : TBits_3; assembler; nostackframe; inline;
    function  getOCM0 : TBits_1; assembler; nostackframe; inline;
    function  getOCM1 : TBits_1; assembler; nostackframe; inline;
    function  getOCM2 : TBits_1; assembler; nostackframe; inline;
    function  getOCSIDL : TBits_1; assembler; nostackframe; inline;
    function  getOCTSEL : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setOC32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCFLT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setOCM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOCTSEL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearOC32;
    procedure clearOCFLT;
    procedure clearOCM0;
    procedure clearOCM1;
    procedure clearOCM2;
    procedure clearOCSIDL;
    procedure clearOCTSEL;
    procedure clearON;
    procedure clearSIDL;
    procedure setOC32;
    procedure setOCFLT;
    procedure setOCM0;
    procedure setOCM1;
    procedure setOCM2;
    procedure setOCSIDL;
    procedure setOCTSEL;
    procedure setON;
    procedure setSIDL;
    property OC32 : TBits_1 read getOC32 write setOC32;
    property OCFLT : TBits_1 read getOCFLT write setOCFLT;
    property OCM : TBits_3 read getOCM write setOCM;
    property OCM0 : TBits_1 read getOCM0 write setOCM0;
    property OCM1 : TBits_1 read getOCM1 write setOCM1;
    property OCM2 : TBits_1 read getOCM2 write setOCM2;
    property OCSIDL : TBits_1 read getOCSIDL write setOCSIDL;
    property OCTSEL : TBits_1 read getOCTSEL write setOCTSEL;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TOCMP5Registers = record
    OC5CONbits : TOCMP5_OC5CON;
    OC5CON : longWord;
    OC5CONCLR : longWord;
    OC5CONSET : longWord;
    OC5CONINV : longWord;
    OC5R : longWord;
    OC5RCLR : longWord;
    OC5RSET : longWord;
    OC5RINV : longWord;
    OC5RS : longWord;
    OC5RSCLR : longWord;
    OC5RSSET : longWord;
    OC5RSINV : longWord;
  end;
  TI2C1_I2C1CON = record
  private
    function  getA10M : TBits_1; assembler; nostackframe; inline;
    function  getACKDT : TBits_1; assembler; nostackframe; inline;
    function  getACKEN : TBits_1; assembler; nostackframe; inline;
    function  getDISSLW : TBits_1; assembler; nostackframe; inline;
    function  getGCEN : TBits_1; assembler; nostackframe; inline;
    function  getI2CEN : TBits_1; assembler; nostackframe; inline;
    function  getI2CSIDL : TBits_1; assembler; nostackframe; inline;
    function  getIPMIEN : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getPEN : TBits_1; assembler; nostackframe; inline;
    function  getRCEN : TBits_1; assembler; nostackframe; inline;
    function  getRSEN : TBits_1; assembler; nostackframe; inline;
    function  getSCLREL : TBits_1; assembler; nostackframe; inline;
    function  getSEN : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getSMEN : TBits_1; assembler; nostackframe; inline;
    function  getSTREN : TBits_1; assembler; nostackframe; inline;
    function  getSTRICT : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setA10M(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setACKDT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setACKEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDISSLW(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setGCEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setI2CEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setI2CSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIPMIEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRCEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRSEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSCLREL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSMEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSTREN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSTRICT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearA10M;
    procedure clearACKDT;
    procedure clearACKEN;
    procedure clearDISSLW;
    procedure clearGCEN;
    procedure clearI2CEN;
    procedure clearI2CSIDL;
    procedure clearIPMIEN;
    procedure clearON;
    procedure clearPEN;
    procedure clearRCEN;
    procedure clearRSEN;
    procedure clearSCLREL;
    procedure clearSEN;
    procedure clearSIDL;
    procedure clearSMEN;
    procedure clearSTREN;
    procedure clearSTRICT;
    procedure setA10M;
    procedure setACKDT;
    procedure setACKEN;
    procedure setDISSLW;
    procedure setGCEN;
    procedure setI2CEN;
    procedure setI2CSIDL;
    procedure setIPMIEN;
    procedure setON;
    procedure setPEN;
    procedure setRCEN;
    procedure setRSEN;
    procedure setSCLREL;
    procedure setSEN;
    procedure setSIDL;
    procedure setSMEN;
    procedure setSTREN;
    procedure setSTRICT;
    property A10M : TBits_1 read getA10M write setA10M;
    property ACKDT : TBits_1 read getACKDT write setACKDT;
    property ACKEN : TBits_1 read getACKEN write setACKEN;
    property DISSLW : TBits_1 read getDISSLW write setDISSLW;
    property GCEN : TBits_1 read getGCEN write setGCEN;
    property I2CEN : TBits_1 read getI2CEN write setI2CEN;
    property I2CSIDL : TBits_1 read getI2CSIDL write setI2CSIDL;
    property IPMIEN : TBits_1 read getIPMIEN write setIPMIEN;
    property ON : TBits_1 read getON write setON;
    property PEN : TBits_1 read getPEN write setPEN;
    property RCEN : TBits_1 read getRCEN write setRCEN;
    property RSEN : TBits_1 read getRSEN write setRSEN;
    property SCLREL : TBits_1 read getSCLREL write setSCLREL;
    property SEN : TBits_1 read getSEN write setSEN;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property SMEN : TBits_1 read getSMEN write setSMEN;
    property STREN : TBits_1 read getSTREN write setSTREN;
    property STRICT : TBits_1 read getSTRICT write setSTRICT;
    property w : TBits_32 read getw write setw;
  end;
  TI2C1_I2C1STAT = record
  private
    function  getACKSTAT : TBits_1; assembler; nostackframe; inline;
    function  getADD10 : TBits_1; assembler; nostackframe; inline;
    function  getBCL : TBits_1; assembler; nostackframe; inline;
    function  getD_A : TBits_1; assembler; nostackframe; inline;
    function  getGCSTAT : TBits_1; assembler; nostackframe; inline;
    function  getI2COV : TBits_1; assembler; nostackframe; inline;
    function  getI2CPOV : TBits_1; assembler; nostackframe; inline;
    function  getIWCOL : TBits_1; assembler; nostackframe; inline;
    function  getP : TBits_1; assembler; nostackframe; inline;
    function  getRBF : TBits_1; assembler; nostackframe; inline;
    function  getR_W : TBits_1; assembler; nostackframe; inline;
    function  getS : TBits_1; assembler; nostackframe; inline;
    function  getTBF : TBits_1; assembler; nostackframe; inline;
    function  getTRSTAT : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setACKSTAT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADD10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBCL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setD_A(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setGCSTAT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setI2COV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setI2CPOV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIWCOL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRBF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setR_W(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTBF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRSTAT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearACKSTAT;
    procedure clearADD10;
    procedure clearBCL;
    procedure clearD_A;
    procedure clearGCSTAT;
    procedure clearI2COV;
    procedure clearI2CPOV;
    procedure clearIWCOL;
    procedure clearP;
    procedure clearRBF;
    procedure clearR_W;
    procedure clearS;
    procedure clearTBF;
    procedure clearTRSTAT;
    procedure setACKSTAT;
    procedure setADD10;
    procedure setBCL;
    procedure setD_A;
    procedure setGCSTAT;
    procedure setI2COV;
    procedure setI2CPOV;
    procedure setIWCOL;
    procedure setP;
    procedure setRBF;
    procedure setR_W;
    procedure setS;
    procedure setTBF;
    procedure setTRSTAT;
    property ACKSTAT : TBits_1 read getACKSTAT write setACKSTAT;
    property ADD10 : TBits_1 read getADD10 write setADD10;
    property BCL : TBits_1 read getBCL write setBCL;
    property D_A : TBits_1 read getD_A write setD_A;
    property GCSTAT : TBits_1 read getGCSTAT write setGCSTAT;
    property I2COV : TBits_1 read getI2COV write setI2COV;
    property I2CPOV : TBits_1 read getI2CPOV write setI2CPOV;
    property IWCOL : TBits_1 read getIWCOL write setIWCOL;
    property P : TBits_1 read getP write setP;
    property RBF : TBits_1 read getRBF write setRBF;
    property R_W : TBits_1 read getR_W write setR_W;
    property S : TBits_1 read getS write setS;
    property TBF : TBits_1 read getTBF write setTBF;
    property TRSTAT : TBits_1 read getTRSTAT write setTRSTAT;
    property w : TBits_32 read getw write setw;
  end;
type
  TI2C1Registers = record
    I2C1CONbits : TI2C1_I2C1CON;
    I2C1CON : longWord;
    I2C1CONCLR : longWord;
    I2C1CONSET : longWord;
    I2C1CONINV : longWord;
    I2C1STATbits : TI2C1_I2C1STAT;
    I2C1STAT : longWord;
    I2C1STATCLR : longWord;
    I2C1STATSET : longWord;
    I2C1STATINV : longWord;
    I2C1ADD : longWord;
    I2C1ADDCLR : longWord;
    I2C1ADDSET : longWord;
    I2C1ADDINV : longWord;
    I2C1MSK : longWord;
    I2C1MSKCLR : longWord;
    I2C1MSKSET : longWord;
    I2C1MSKINV : longWord;
    I2C1BRG : longWord;
    I2C1BRGCLR : longWord;
    I2C1BRGSET : longWord;
    I2C1BRGINV : longWord;
    I2C1TRN : longWord;
    I2C1TRNCLR : longWord;
    I2C1TRNSET : longWord;
    I2C1TRNINV : longWord;
    I2C1RCV : longWord;
  end;
  TI2C2_I2C2CON = record
  private
    function  getA10M : TBits_1; assembler; nostackframe; inline;
    function  getACKDT : TBits_1; assembler; nostackframe; inline;
    function  getACKEN : TBits_1; assembler; nostackframe; inline;
    function  getDISSLW : TBits_1; assembler; nostackframe; inline;
    function  getGCEN : TBits_1; assembler; nostackframe; inline;
    function  getI2CEN : TBits_1; assembler; nostackframe; inline;
    function  getI2CSIDL : TBits_1; assembler; nostackframe; inline;
    function  getIPMIEN : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getPEN : TBits_1; assembler; nostackframe; inline;
    function  getRCEN : TBits_1; assembler; nostackframe; inline;
    function  getRSEN : TBits_1; assembler; nostackframe; inline;
    function  getSCLREL : TBits_1; assembler; nostackframe; inline;
    function  getSEN : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getSMEN : TBits_1; assembler; nostackframe; inline;
    function  getSTREN : TBits_1; assembler; nostackframe; inline;
    function  getSTRICT : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setA10M(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setACKDT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setACKEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDISSLW(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setGCEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setI2CEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setI2CSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIPMIEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRCEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRSEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSCLREL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSMEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSTREN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSTRICT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearA10M;
    procedure clearACKDT;
    procedure clearACKEN;
    procedure clearDISSLW;
    procedure clearGCEN;
    procedure clearI2CEN;
    procedure clearI2CSIDL;
    procedure clearIPMIEN;
    procedure clearON;
    procedure clearPEN;
    procedure clearRCEN;
    procedure clearRSEN;
    procedure clearSCLREL;
    procedure clearSEN;
    procedure clearSIDL;
    procedure clearSMEN;
    procedure clearSTREN;
    procedure clearSTRICT;
    procedure setA10M;
    procedure setACKDT;
    procedure setACKEN;
    procedure setDISSLW;
    procedure setGCEN;
    procedure setI2CEN;
    procedure setI2CSIDL;
    procedure setIPMIEN;
    procedure setON;
    procedure setPEN;
    procedure setRCEN;
    procedure setRSEN;
    procedure setSCLREL;
    procedure setSEN;
    procedure setSIDL;
    procedure setSMEN;
    procedure setSTREN;
    procedure setSTRICT;
    property A10M : TBits_1 read getA10M write setA10M;
    property ACKDT : TBits_1 read getACKDT write setACKDT;
    property ACKEN : TBits_1 read getACKEN write setACKEN;
    property DISSLW : TBits_1 read getDISSLW write setDISSLW;
    property GCEN : TBits_1 read getGCEN write setGCEN;
    property I2CEN : TBits_1 read getI2CEN write setI2CEN;
    property I2CSIDL : TBits_1 read getI2CSIDL write setI2CSIDL;
    property IPMIEN : TBits_1 read getIPMIEN write setIPMIEN;
    property ON : TBits_1 read getON write setON;
    property PEN : TBits_1 read getPEN write setPEN;
    property RCEN : TBits_1 read getRCEN write setRCEN;
    property RSEN : TBits_1 read getRSEN write setRSEN;
    property SCLREL : TBits_1 read getSCLREL write setSCLREL;
    property SEN : TBits_1 read getSEN write setSEN;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property SMEN : TBits_1 read getSMEN write setSMEN;
    property STREN : TBits_1 read getSTREN write setSTREN;
    property STRICT : TBits_1 read getSTRICT write setSTRICT;
    property w : TBits_32 read getw write setw;
  end;
  TI2C2_I2C2STAT = record
  private
    function  getACKSTAT : TBits_1; assembler; nostackframe; inline;
    function  getADD10 : TBits_1; assembler; nostackframe; inline;
    function  getBCL : TBits_1; assembler; nostackframe; inline;
    function  getD_A : TBits_1; assembler; nostackframe; inline;
    function  getGCSTAT : TBits_1; assembler; nostackframe; inline;
    function  getI2COV : TBits_1; assembler; nostackframe; inline;
    function  getI2CPOV : TBits_1; assembler; nostackframe; inline;
    function  getIWCOL : TBits_1; assembler; nostackframe; inline;
    function  getP : TBits_1; assembler; nostackframe; inline;
    function  getRBF : TBits_1; assembler; nostackframe; inline;
    function  getR_W : TBits_1; assembler; nostackframe; inline;
    function  getS : TBits_1; assembler; nostackframe; inline;
    function  getTBF : TBits_1; assembler; nostackframe; inline;
    function  getTRSTAT : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setACKSTAT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADD10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBCL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setD_A(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setGCSTAT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setI2COV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setI2CPOV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIWCOL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRBF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setR_W(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTBF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRSTAT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearACKSTAT;
    procedure clearADD10;
    procedure clearBCL;
    procedure clearD_A;
    procedure clearGCSTAT;
    procedure clearI2COV;
    procedure clearI2CPOV;
    procedure clearIWCOL;
    procedure clearP;
    procedure clearRBF;
    procedure clearR_W;
    procedure clearS;
    procedure clearTBF;
    procedure clearTRSTAT;
    procedure setACKSTAT;
    procedure setADD10;
    procedure setBCL;
    procedure setD_A;
    procedure setGCSTAT;
    procedure setI2COV;
    procedure setI2CPOV;
    procedure setIWCOL;
    procedure setP;
    procedure setRBF;
    procedure setR_W;
    procedure setS;
    procedure setTBF;
    procedure setTRSTAT;
    property ACKSTAT : TBits_1 read getACKSTAT write setACKSTAT;
    property ADD10 : TBits_1 read getADD10 write setADD10;
    property BCL : TBits_1 read getBCL write setBCL;
    property D_A : TBits_1 read getD_A write setD_A;
    property GCSTAT : TBits_1 read getGCSTAT write setGCSTAT;
    property I2COV : TBits_1 read getI2COV write setI2COV;
    property I2CPOV : TBits_1 read getI2CPOV write setI2CPOV;
    property IWCOL : TBits_1 read getIWCOL write setIWCOL;
    property P : TBits_1 read getP write setP;
    property RBF : TBits_1 read getRBF write setRBF;
    property R_W : TBits_1 read getR_W write setR_W;
    property S : TBits_1 read getS write setS;
    property TBF : TBits_1 read getTBF write setTBF;
    property TRSTAT : TBits_1 read getTRSTAT write setTRSTAT;
    property w : TBits_32 read getw write setw;
  end;
type
  TI2C2Registers = record
    I2C2CONbits : TI2C2_I2C2CON;
    I2C2CON : longWord;
    I2C2CONCLR : longWord;
    I2C2CONSET : longWord;
    I2C2CONINV : longWord;
    I2C2STATbits : TI2C2_I2C2STAT;
    I2C2STAT : longWord;
    I2C2STATCLR : longWord;
    I2C2STATSET : longWord;
    I2C2STATINV : longWord;
    I2C2ADD : longWord;
    I2C2ADDCLR : longWord;
    I2C2ADDSET : longWord;
    I2C2ADDINV : longWord;
    I2C2MSK : longWord;
    I2C2MSKCLR : longWord;
    I2C2MSKSET : longWord;
    I2C2MSKINV : longWord;
    I2C2BRG : longWord;
    I2C2BRGCLR : longWord;
    I2C2BRGSET : longWord;
    I2C2BRGINV : longWord;
    I2C2TRN : longWord;
    I2C2TRNCLR : longWord;
    I2C2TRNSET : longWord;
    I2C2TRNINV : longWord;
    I2C2RCV : longWord;
  end;
  TSPI2_SPI2CON = record
  private
    function  getCKE : TBits_1; assembler; nostackframe; inline;
    function  getCKP : TBits_1; assembler; nostackframe; inline;
    function  getDISSDO : TBits_1; assembler; nostackframe; inline;
    function  getFRMEN : TBits_1; assembler; nostackframe; inline;
    function  getFRMPOL : TBits_1; assembler; nostackframe; inline;
    function  getFRMSYNC : TBits_1; assembler; nostackframe; inline;
    function  getMODE16 : TBits_1; assembler; nostackframe; inline;
    function  getMODE32 : TBits_1; assembler; nostackframe; inline;
    function  getMSTEN : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getSMP : TBits_1; assembler; nostackframe; inline;
    function  getSPIFE : TBits_1; assembler; nostackframe; inline;
    function  getSSEN : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCKE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCKP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDISSDO(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRMEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRMPOL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRMSYNC(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setMODE16(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setMODE32(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setMSTEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSMP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSPIFE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSSEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCKE;
    procedure clearCKP;
    procedure clearDISSDO;
    procedure clearFRMEN;
    procedure clearFRMPOL;
    procedure clearFRMSYNC;
    procedure clearMODE16;
    procedure clearMODE32;
    procedure clearMSTEN;
    procedure clearON;
    procedure clearSIDL;
    procedure clearSMP;
    procedure clearSPIFE;
    procedure clearSSEN;
    procedure setCKE;
    procedure setCKP;
    procedure setDISSDO;
    procedure setFRMEN;
    procedure setFRMPOL;
    procedure setFRMSYNC;
    procedure setMODE16;
    procedure setMODE32;
    procedure setMSTEN;
    procedure setON;
    procedure setSIDL;
    procedure setSMP;
    procedure setSPIFE;
    procedure setSSEN;
    property CKE : TBits_1 read getCKE write setCKE;
    property CKP : TBits_1 read getCKP write setCKP;
    property DISSDO : TBits_1 read getDISSDO write setDISSDO;
    property FRMEN : TBits_1 read getFRMEN write setFRMEN;
    property FRMPOL : TBits_1 read getFRMPOL write setFRMPOL;
    property FRMSYNC : TBits_1 read getFRMSYNC write setFRMSYNC;
    property MODE16 : TBits_1 read getMODE16 write setMODE16;
    property MODE32 : TBits_1 read getMODE32 write setMODE32;
    property MSTEN : TBits_1 read getMSTEN write setMSTEN;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property SMP : TBits_1 read getSMP write setSMP;
    property SPIFE : TBits_1 read getSPIFE write setSPIFE;
    property SSEN : TBits_1 read getSSEN write setSSEN;
    property w : TBits_32 read getw write setw;
  end;
  TSPI2_SPI2STAT = record
  private
    function  getSPIBUSY : TBits_1; assembler; nostackframe; inline;
    function  getSPIRBF : TBits_1; assembler; nostackframe; inline;
    function  getSPIROV : TBits_1; assembler; nostackframe; inline;
    function  getSPITBE : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setSPIBUSY(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSPIRBF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSPIROV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSPITBE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearSPIBUSY;
    procedure clearSPIRBF;
    procedure clearSPIROV;
    procedure clearSPITBE;
    procedure setSPIBUSY;
    procedure setSPIRBF;
    procedure setSPIROV;
    procedure setSPITBE;
    property SPIBUSY : TBits_1 read getSPIBUSY write setSPIBUSY;
    property SPIRBF : TBits_1 read getSPIRBF write setSPIRBF;
    property SPIROV : TBits_1 read getSPIROV write setSPIROV;
    property SPITBE : TBits_1 read getSPITBE write setSPITBE;
    property w : TBits_32 read getw write setw;
  end;
type
  TSPI2Registers = record
    SPI2CONbits : TSPI2_SPI2CON;
    SPI2CON : longWord;
    SPI2CONCLR : longWord;
    SPI2CONSET : longWord;
    SPI2CONINV : longWord;
    SPI2STATbits : TSPI2_SPI2STAT;
    SPI2STAT : longWord;
    SPI2STATCLR : longWord;
    SPI2STATSET : longWord;
    SPI2STATINV : longWord;
    SPI2BUF : longWord;
    SPI2BRG : longWord;
    SPI2BRGCLR : longWord;
    SPI2BRGSET : longWord;
    SPI2BRGINV : longWord;
  end;
  TUART1_U1MODE = record
  private
    function  getABAUD : TBits_1; assembler; nostackframe; inline;
    function  getBRGH : TBits_1; assembler; nostackframe; inline;
    function  getIREN : TBits_1; assembler; nostackframe; inline;
    function  getLPBACK : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getPDSEL : TBits_2; assembler; nostackframe; inline;
    function  getPDSEL0 : TBits_1; assembler; nostackframe; inline;
    function  getPDSEL1 : TBits_1; assembler; nostackframe; inline;
    function  getRTSMD : TBits_1; assembler; nostackframe; inline;
    function  getRXINV : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getSTSEL : TBits_1; assembler; nostackframe; inline;
    function  getUARTEN : TBits_1; assembler; nostackframe; inline;
    function  getUEN : TBits_2; assembler; nostackframe; inline;
    function  getUEN0 : TBits_1; assembler; nostackframe; inline;
    function  getUEN1 : TBits_1; assembler; nostackframe; inline;
    function  getUSIDL : TBits_1; assembler; nostackframe; inline;
    function  getWAKE : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setABAUD(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBRGH(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIREN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLPBACK(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPDSEL(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setPDSEL0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPDSEL1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRTSMD(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRXINV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSTSEL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUARTEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUEN(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setUEN0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUEN1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWAKE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearABAUD;
    procedure clearBRGH;
    procedure clearIREN;
    procedure clearLPBACK;
    procedure clearON;
    procedure clearPDSEL0;
    procedure clearPDSEL1;
    procedure clearRTSMD;
    procedure clearRXINV;
    procedure clearSIDL;
    procedure clearSTSEL;
    procedure clearUARTEN;
    procedure clearUEN0;
    procedure clearUEN1;
    procedure clearUSIDL;
    procedure clearWAKE;
    procedure setABAUD;
    procedure setBRGH;
    procedure setIREN;
    procedure setLPBACK;
    procedure setON;
    procedure setPDSEL0;
    procedure setPDSEL1;
    procedure setRTSMD;
    procedure setRXINV;
    procedure setSIDL;
    procedure setSTSEL;
    procedure setUARTEN;
    procedure setUEN0;
    procedure setUEN1;
    procedure setUSIDL;
    procedure setWAKE;
    property ABAUD : TBits_1 read getABAUD write setABAUD;
    property BRGH : TBits_1 read getBRGH write setBRGH;
    property IREN : TBits_1 read getIREN write setIREN;
    property LPBACK : TBits_1 read getLPBACK write setLPBACK;
    property ON : TBits_1 read getON write setON;
    property PDSEL : TBits_2 read getPDSEL write setPDSEL;
    property PDSEL0 : TBits_1 read getPDSEL0 write setPDSEL0;
    property PDSEL1 : TBits_1 read getPDSEL1 write setPDSEL1;
    property RTSMD : TBits_1 read getRTSMD write setRTSMD;
    property RXINV : TBits_1 read getRXINV write setRXINV;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property STSEL : TBits_1 read getSTSEL write setSTSEL;
    property UARTEN : TBits_1 read getUARTEN write setUARTEN;
    property UEN : TBits_2 read getUEN write setUEN;
    property UEN0 : TBits_1 read getUEN0 write setUEN0;
    property UEN1 : TBits_1 read getUEN1 write setUEN1;
    property USIDL : TBits_1 read getUSIDL write setUSIDL;
    property WAKE : TBits_1 read getWAKE write setWAKE;
    property w : TBits_32 read getw write setw;
  end;
  TUART1_U1STA = record
  private
    function  getADDEN : TBits_1; assembler; nostackframe; inline;
    function  getADDR : TBits_8; assembler; nostackframe; inline;
    function  getADM_EN : TBits_1; assembler; nostackframe; inline;
    function  getFERR : TBits_1; assembler; nostackframe; inline;
    function  getOERR : TBits_1; assembler; nostackframe; inline;
    function  getPERR : TBits_1; assembler; nostackframe; inline;
    function  getRIDLE : TBits_1; assembler; nostackframe; inline;
    function  getTRMT : TBits_1; assembler; nostackframe; inline;
    function  getURXDA : TBits_1; assembler; nostackframe; inline;
    function  getURXEN : TBits_1; assembler; nostackframe; inline;
    function  getURXISEL : TBits_2; assembler; nostackframe; inline;
    function  getURXISEL0 : TBits_1; assembler; nostackframe; inline;
    function  getURXISEL1 : TBits_1; assembler; nostackframe; inline;
    function  getUTXBF : TBits_1; assembler; nostackframe; inline;
    function  getUTXBRK : TBits_1; assembler; nostackframe; inline;
    function  getUTXEN : TBits_1; assembler; nostackframe; inline;
    function  getUTXINV : TBits_1; assembler; nostackframe; inline;
    function  getUTXISEL : TBits_2; assembler; nostackframe; inline;
    function  getUTXISEL0 : TBits_1; assembler; nostackframe; inline;
    function  getUTXISEL1 : TBits_1; assembler; nostackframe; inline;
    function  getUTXSEL : TBits_2; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setADDEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADDR(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setADM_EN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFERR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOERR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPERR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRIDLE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRMT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setURXDA(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setURXEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setURXISEL(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setURXISEL0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setURXISEL1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXBF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXBRK(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXINV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXISEL(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setUTXISEL0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXISEL1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXSEL(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearADDEN;
    procedure clearADM_EN;
    procedure clearFERR;
    procedure clearOERR;
    procedure clearPERR;
    procedure clearRIDLE;
    procedure clearTRMT;
    procedure clearURXDA;
    procedure clearURXEN;
    procedure clearURXISEL0;
    procedure clearURXISEL1;
    procedure clearUTXBF;
    procedure clearUTXBRK;
    procedure clearUTXEN;
    procedure clearUTXINV;
    procedure clearUTXISEL0;
    procedure clearUTXISEL1;
    procedure setADDEN;
    procedure setADM_EN;
    procedure setFERR;
    procedure setOERR;
    procedure setPERR;
    procedure setRIDLE;
    procedure setTRMT;
    procedure setURXDA;
    procedure setURXEN;
    procedure setURXISEL0;
    procedure setURXISEL1;
    procedure setUTXBF;
    procedure setUTXBRK;
    procedure setUTXEN;
    procedure setUTXINV;
    procedure setUTXISEL0;
    procedure setUTXISEL1;
    property ADDEN : TBits_1 read getADDEN write setADDEN;
    property ADDR : TBits_8 read getADDR write setADDR;
    property ADM_EN : TBits_1 read getADM_EN write setADM_EN;
    property FERR : TBits_1 read getFERR write setFERR;
    property OERR : TBits_1 read getOERR write setOERR;
    property PERR : TBits_1 read getPERR write setPERR;
    property RIDLE : TBits_1 read getRIDLE write setRIDLE;
    property TRMT : TBits_1 read getTRMT write setTRMT;
    property URXDA : TBits_1 read getURXDA write setURXDA;
    property URXEN : TBits_1 read getURXEN write setURXEN;
    property URXISEL : TBits_2 read getURXISEL write setURXISEL;
    property URXISEL0 : TBits_1 read getURXISEL0 write setURXISEL0;
    property URXISEL1 : TBits_1 read getURXISEL1 write setURXISEL1;
    property UTXBF : TBits_1 read getUTXBF write setUTXBF;
    property UTXBRK : TBits_1 read getUTXBRK write setUTXBRK;
    property UTXEN : TBits_1 read getUTXEN write setUTXEN;
    property UTXINV : TBits_1 read getUTXINV write setUTXINV;
    property UTXISEL : TBits_2 read getUTXISEL write setUTXISEL;
    property UTXISEL0 : TBits_1 read getUTXISEL0 write setUTXISEL0;
    property UTXISEL1 : TBits_1 read getUTXISEL1 write setUTXISEL1;
    property UTXSEL : TBits_2 read getUTXSEL write setUTXSEL;
    property w : TBits_32 read getw write setw;
  end;
type
  TUART1Registers = record
    U1MODEbits : TUART1_U1MODE;
    U1MODE : longWord;
    U1MODECLR : longWord;
    U1MODESET : longWord;
    U1MODEINV : longWord;
    U1STAbits : TUART1_U1STA;
    U1STA : longWord;
    U1STACLR : longWord;
    U1STASET : longWord;
    U1STAINV : longWord;
    U1TXREG : longWord;
    U1RXREG : longWord;
    U1BRG : longWord;
    U1BRGCLR : longWord;
    U1BRGSET : longWord;
    U1BRGINV : longWord;
  end;
  TUART2_U2MODE = record
  private
    function  getABAUD : TBits_1; assembler; nostackframe; inline;
    function  getBRGH : TBits_1; assembler; nostackframe; inline;
    function  getIREN : TBits_1; assembler; nostackframe; inline;
    function  getLPBACK : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getPDSEL : TBits_2; assembler; nostackframe; inline;
    function  getPDSEL0 : TBits_1; assembler; nostackframe; inline;
    function  getPDSEL1 : TBits_1; assembler; nostackframe; inline;
    function  getRTSMD : TBits_1; assembler; nostackframe; inline;
    function  getRXINV : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getSTSEL : TBits_1; assembler; nostackframe; inline;
    function  getUARTEN : TBits_1; assembler; nostackframe; inline;
    function  getUEN : TBits_2; assembler; nostackframe; inline;
    function  getUEN0 : TBits_1; assembler; nostackframe; inline;
    function  getUEN1 : TBits_1; assembler; nostackframe; inline;
    function  getUSIDL : TBits_1; assembler; nostackframe; inline;
    function  getWAKE : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setABAUD(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBRGH(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIREN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLPBACK(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPDSEL(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setPDSEL0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPDSEL1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRTSMD(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRXINV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSTSEL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUARTEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUEN(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setUEN0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUEN1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWAKE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearABAUD;
    procedure clearBRGH;
    procedure clearIREN;
    procedure clearLPBACK;
    procedure clearON;
    procedure clearPDSEL0;
    procedure clearPDSEL1;
    procedure clearRTSMD;
    procedure clearRXINV;
    procedure clearSIDL;
    procedure clearSTSEL;
    procedure clearUARTEN;
    procedure clearUEN0;
    procedure clearUEN1;
    procedure clearUSIDL;
    procedure clearWAKE;
    procedure setABAUD;
    procedure setBRGH;
    procedure setIREN;
    procedure setLPBACK;
    procedure setON;
    procedure setPDSEL0;
    procedure setPDSEL1;
    procedure setRTSMD;
    procedure setRXINV;
    procedure setSIDL;
    procedure setSTSEL;
    procedure setUARTEN;
    procedure setUEN0;
    procedure setUEN1;
    procedure setUSIDL;
    procedure setWAKE;
    property ABAUD : TBits_1 read getABAUD write setABAUD;
    property BRGH : TBits_1 read getBRGH write setBRGH;
    property IREN : TBits_1 read getIREN write setIREN;
    property LPBACK : TBits_1 read getLPBACK write setLPBACK;
    property ON : TBits_1 read getON write setON;
    property PDSEL : TBits_2 read getPDSEL write setPDSEL;
    property PDSEL0 : TBits_1 read getPDSEL0 write setPDSEL0;
    property PDSEL1 : TBits_1 read getPDSEL1 write setPDSEL1;
    property RTSMD : TBits_1 read getRTSMD write setRTSMD;
    property RXINV : TBits_1 read getRXINV write setRXINV;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property STSEL : TBits_1 read getSTSEL write setSTSEL;
    property UARTEN : TBits_1 read getUARTEN write setUARTEN;
    property UEN : TBits_2 read getUEN write setUEN;
    property UEN0 : TBits_1 read getUEN0 write setUEN0;
    property UEN1 : TBits_1 read getUEN1 write setUEN1;
    property USIDL : TBits_1 read getUSIDL write setUSIDL;
    property WAKE : TBits_1 read getWAKE write setWAKE;
    property w : TBits_32 read getw write setw;
  end;
  TUART2_U2STA = record
  private
    function  getADDEN : TBits_1; assembler; nostackframe; inline;
    function  getADDR : TBits_8; assembler; nostackframe; inline;
    function  getADM_EN : TBits_1; assembler; nostackframe; inline;
    function  getFERR : TBits_1; assembler; nostackframe; inline;
    function  getOERR : TBits_1; assembler; nostackframe; inline;
    function  getPERR : TBits_1; assembler; nostackframe; inline;
    function  getRIDLE : TBits_1; assembler; nostackframe; inline;
    function  getTRMT : TBits_1; assembler; nostackframe; inline;
    function  getURXDA : TBits_1; assembler; nostackframe; inline;
    function  getURXEN : TBits_1; assembler; nostackframe; inline;
    function  getURXISEL : TBits_2; assembler; nostackframe; inline;
    function  getURXISEL0 : TBits_1; assembler; nostackframe; inline;
    function  getURXISEL1 : TBits_1; assembler; nostackframe; inline;
    function  getUTXBF : TBits_1; assembler; nostackframe; inline;
    function  getUTXBRK : TBits_1; assembler; nostackframe; inline;
    function  getUTXEN : TBits_1; assembler; nostackframe; inline;
    function  getUTXINV : TBits_1; assembler; nostackframe; inline;
    function  getUTXISEL : TBits_2; assembler; nostackframe; inline;
    function  getUTXISEL0 : TBits_1; assembler; nostackframe; inline;
    function  getUTXISEL1 : TBits_1; assembler; nostackframe; inline;
    function  getUTXSEL : TBits_2; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setADDEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADDR(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setADM_EN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFERR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOERR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPERR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRIDLE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRMT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setURXDA(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setURXEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setURXISEL(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setURXISEL0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setURXISEL1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXBF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXBRK(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXINV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXISEL(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setUTXISEL0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXISEL1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUTXSEL(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearADDEN;
    procedure clearADM_EN;
    procedure clearFERR;
    procedure clearOERR;
    procedure clearPERR;
    procedure clearRIDLE;
    procedure clearTRMT;
    procedure clearURXDA;
    procedure clearURXEN;
    procedure clearURXISEL0;
    procedure clearURXISEL1;
    procedure clearUTXBF;
    procedure clearUTXBRK;
    procedure clearUTXEN;
    procedure clearUTXINV;
    procedure clearUTXISEL0;
    procedure clearUTXISEL1;
    procedure setADDEN;
    procedure setADM_EN;
    procedure setFERR;
    procedure setOERR;
    procedure setPERR;
    procedure setRIDLE;
    procedure setTRMT;
    procedure setURXDA;
    procedure setURXEN;
    procedure setURXISEL0;
    procedure setURXISEL1;
    procedure setUTXBF;
    procedure setUTXBRK;
    procedure setUTXEN;
    procedure setUTXINV;
    procedure setUTXISEL0;
    procedure setUTXISEL1;
    property ADDEN : TBits_1 read getADDEN write setADDEN;
    property ADDR : TBits_8 read getADDR write setADDR;
    property ADM_EN : TBits_1 read getADM_EN write setADM_EN;
    property FERR : TBits_1 read getFERR write setFERR;
    property OERR : TBits_1 read getOERR write setOERR;
    property PERR : TBits_1 read getPERR write setPERR;
    property RIDLE : TBits_1 read getRIDLE write setRIDLE;
    property TRMT : TBits_1 read getTRMT write setTRMT;
    property URXDA : TBits_1 read getURXDA write setURXDA;
    property URXEN : TBits_1 read getURXEN write setURXEN;
    property URXISEL : TBits_2 read getURXISEL write setURXISEL;
    property URXISEL0 : TBits_1 read getURXISEL0 write setURXISEL0;
    property URXISEL1 : TBits_1 read getURXISEL1 write setURXISEL1;
    property UTXBF : TBits_1 read getUTXBF write setUTXBF;
    property UTXBRK : TBits_1 read getUTXBRK write setUTXBRK;
    property UTXEN : TBits_1 read getUTXEN write setUTXEN;
    property UTXINV : TBits_1 read getUTXINV write setUTXINV;
    property UTXISEL : TBits_2 read getUTXISEL write setUTXISEL;
    property UTXISEL0 : TBits_1 read getUTXISEL0 write setUTXISEL0;
    property UTXISEL1 : TBits_1 read getUTXISEL1 write setUTXISEL1;
    property UTXSEL : TBits_2 read getUTXSEL write setUTXSEL;
    property w : TBits_32 read getw write setw;
  end;
type
  TUART2Registers = record
    U2MODEbits : TUART2_U2MODE;
    U2MODE : longWord;
    U2MODECLR : longWord;
    U2MODESET : longWord;
    U2MODEINV : longWord;
    U2STAbits : TUART2_U2STA;
    U2STA : longWord;
    U2STACLR : longWord;
    U2STASET : longWord;
    U2STAINV : longWord;
    U2TXREG : longWord;
    U2RXREG : longWord;
    U2BRG : longWord;
    U2BRGCLR : longWord;
    U2BRGSET : longWord;
    U2BRGINV : longWord;
  end;
  TPMP_PMCON = record
  private
    function  getADRMUX : TBits_2; assembler; nostackframe; inline;
    function  getADRMUX0 : TBits_1; assembler; nostackframe; inline;
    function  getADRMUX1 : TBits_1; assembler; nostackframe; inline;
    function  getALP : TBits_1; assembler; nostackframe; inline;
    function  getCS1P : TBits_1; assembler; nostackframe; inline;
    function  getCS2P : TBits_1; assembler; nostackframe; inline;
    function  getCSF : TBits_2; assembler; nostackframe; inline;
    function  getCSF0 : TBits_1; assembler; nostackframe; inline;
    function  getCSF1 : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getPMPEN : TBits_1; assembler; nostackframe; inline;
    function  getPMPTTL : TBits_1; assembler; nostackframe; inline;
    function  getPSIDL : TBits_1; assembler; nostackframe; inline;
    function  getPTRDEN : TBits_1; assembler; nostackframe; inline;
    function  getPTWREN : TBits_1; assembler; nostackframe; inline;
    function  getRDSP : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getWRSP : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setADRMUX(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setADRMUX0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADRMUX1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setALP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCS1P(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCS2P(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSF(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setCSF0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSF1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPMPEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPMPTTL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTRDEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTWREN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRDSP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWRSP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearADRMUX0;
    procedure clearADRMUX1;
    procedure clearALP;
    procedure clearCS1P;
    procedure clearCS2P;
    procedure clearCSF0;
    procedure clearCSF1;
    procedure clearON;
    procedure clearPMPEN;
    procedure clearPMPTTL;
    procedure clearPSIDL;
    procedure clearPTRDEN;
    procedure clearPTWREN;
    procedure clearRDSP;
    procedure clearSIDL;
    procedure clearWRSP;
    procedure setADRMUX0;
    procedure setADRMUX1;
    procedure setALP;
    procedure setCS1P;
    procedure setCS2P;
    procedure setCSF0;
    procedure setCSF1;
    procedure setON;
    procedure setPMPEN;
    procedure setPMPTTL;
    procedure setPSIDL;
    procedure setPTRDEN;
    procedure setPTWREN;
    procedure setRDSP;
    procedure setSIDL;
    procedure setWRSP;
    property ADRMUX : TBits_2 read getADRMUX write setADRMUX;
    property ADRMUX0 : TBits_1 read getADRMUX0 write setADRMUX0;
    property ADRMUX1 : TBits_1 read getADRMUX1 write setADRMUX1;
    property ALP : TBits_1 read getALP write setALP;
    property CS1P : TBits_1 read getCS1P write setCS1P;
    property CS2P : TBits_1 read getCS2P write setCS2P;
    property CSF : TBits_2 read getCSF write setCSF;
    property CSF0 : TBits_1 read getCSF0 write setCSF0;
    property CSF1 : TBits_1 read getCSF1 write setCSF1;
    property ON : TBits_1 read getON write setON;
    property PMPEN : TBits_1 read getPMPEN write setPMPEN;
    property PMPTTL : TBits_1 read getPMPTTL write setPMPTTL;
    property PSIDL : TBits_1 read getPSIDL write setPSIDL;
    property PTRDEN : TBits_1 read getPTRDEN write setPTRDEN;
    property PTWREN : TBits_1 read getPTWREN write setPTWREN;
    property RDSP : TBits_1 read getRDSP write setRDSP;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property WRSP : TBits_1 read getWRSP write setWRSP;
    property w : TBits_32 read getw write setw;
  end;
  TPMP_PMMODE = record
  private
    function  getBUSY : TBits_1; assembler; nostackframe; inline;
    function  getINCM : TBits_2; assembler; nostackframe; inline;
    function  getINCM0 : TBits_1; assembler; nostackframe; inline;
    function  getINCM1 : TBits_1; assembler; nostackframe; inline;
    function  getIRQM : TBits_2; assembler; nostackframe; inline;
    function  getIRQM0 : TBits_1; assembler; nostackframe; inline;
    function  getIRQM1 : TBits_1; assembler; nostackframe; inline;
    function  getMODE : TBits_2; assembler; nostackframe; inline;
    function  getMODE0 : TBits_1; assembler; nostackframe; inline;
    function  getMODE1 : TBits_1; assembler; nostackframe; inline;
    function  getMODE16 : TBits_1; assembler; nostackframe; inline;
    function  getWAITB : TBits_2; assembler; nostackframe; inline;
    function  getWAITB0 : TBits_1; assembler; nostackframe; inline;
    function  getWAITB1 : TBits_1; assembler; nostackframe; inline;
    function  getWAITE : TBits_2; assembler; nostackframe; inline;
    function  getWAITE0 : TBits_1; assembler; nostackframe; inline;
    function  getWAITE1 : TBits_1; assembler; nostackframe; inline;
    function  getWAITM : TBits_4; assembler; nostackframe; inline;
    function  getWAITM0 : TBits_1; assembler; nostackframe; inline;
    function  getWAITM1 : TBits_1; assembler; nostackframe; inline;
    function  getWAITM2 : TBits_1; assembler; nostackframe; inline;
    function  getWAITM3 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setBUSY(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setINCM(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setINCM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setINCM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIRQM(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setIRQM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIRQM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setMODE(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setMODE0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setMODE1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setMODE16(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWAITB(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setWAITB0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWAITB1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWAITE(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setWAITE0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWAITE1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWAITM(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setWAITM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWAITM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWAITM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWAITM3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearBUSY;
    procedure clearINCM0;
    procedure clearINCM1;
    procedure clearIRQM0;
    procedure clearIRQM1;
    procedure clearMODE0;
    procedure clearMODE16;
    procedure clearMODE1;
    procedure clearWAITB0;
    procedure clearWAITB1;
    procedure clearWAITE0;
    procedure clearWAITE1;
    procedure clearWAITM0;
    procedure clearWAITM1;
    procedure clearWAITM2;
    procedure clearWAITM3;
    procedure setBUSY;
    procedure setINCM0;
    procedure setINCM1;
    procedure setIRQM0;
    procedure setIRQM1;
    procedure setMODE0;
    procedure setMODE16;
    procedure setMODE1;
    procedure setWAITB0;
    procedure setWAITB1;
    procedure setWAITE0;
    procedure setWAITE1;
    procedure setWAITM0;
    procedure setWAITM1;
    procedure setWAITM2;
    procedure setWAITM3;
    property BUSY : TBits_1 read getBUSY write setBUSY;
    property INCM : TBits_2 read getINCM write setINCM;
    property INCM0 : TBits_1 read getINCM0 write setINCM0;
    property INCM1 : TBits_1 read getINCM1 write setINCM1;
    property IRQM : TBits_2 read getIRQM write setIRQM;
    property IRQM0 : TBits_1 read getIRQM0 write setIRQM0;
    property IRQM1 : TBits_1 read getIRQM1 write setIRQM1;
    property MODE : TBits_2 read getMODE write setMODE;
    property MODE0 : TBits_1 read getMODE0 write setMODE0;
    property MODE1 : TBits_1 read getMODE1 write setMODE1;
    property MODE16 : TBits_1 read getMODE16 write setMODE16;
    property WAITB : TBits_2 read getWAITB write setWAITB;
    property WAITB0 : TBits_1 read getWAITB0 write setWAITB0;
    property WAITB1 : TBits_1 read getWAITB1 write setWAITB1;
    property WAITE : TBits_2 read getWAITE write setWAITE;
    property WAITE0 : TBits_1 read getWAITE0 write setWAITE0;
    property WAITE1 : TBits_1 read getWAITE1 write setWAITE1;
    property WAITM : TBits_4 read getWAITM write setWAITM;
    property WAITM0 : TBits_1 read getWAITM0 write setWAITM0;
    property WAITM1 : TBits_1 read getWAITM1 write setWAITM1;
    property WAITM2 : TBits_1 read getWAITM2 write setWAITM2;
    property WAITM3 : TBits_1 read getWAITM3 write setWAITM3;
    property w : TBits_32 read getw write setw;
  end;
  TPMP_PMADDR = record
  private
    function  getADDR : TBits_14; assembler; nostackframe; inline;
    function  getCS : TBits_2; assembler; nostackframe; inline;
    function  getCS1 : TBits_1; assembler; nostackframe; inline;
    function  getCS2 : TBits_1; assembler; nostackframe; inline;
    function  getPADDR : TBits_14; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setADDR(thebits : TBits_14); assembler; nostackframe; inline;
    procedure setCS(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setCS1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCS2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPADDR(thebits : TBits_14); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCS1;
    procedure clearCS2;
    procedure setCS1;
    procedure setCS2;
    property ADDR : TBits_14 read getADDR write setADDR;
    property CS : TBits_2 read getCS write setCS;
    property CS1 : TBits_1 read getCS1 write setCS1;
    property CS2 : TBits_1 read getCS2 write setCS2;
    property PADDR : TBits_14 read getPADDR write setPADDR;
    property w : TBits_32 read getw write setw;
  end;
  TPMP_PMDOUT = record
  private
    function  getDATAOUT : TBits_32; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setDATAOUT(thebits : TBits_32); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    property DATAOUT : TBits_32 read getDATAOUT write setDATAOUT;
    property w : TBits_32 read getw write setw;
  end;
  TPMP_PMDIN = record
  private
    function  getDATAIN : TBits_32; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setDATAIN(thebits : TBits_32); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    property DATAIN : TBits_32 read getDATAIN write setDATAIN;
    property w : TBits_32 read getw write setw;
  end;
  TPMP_PMAEN = record
  private
    function  getPTEN : TBits_16; assembler; nostackframe; inline;
    function  getPTEN0 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN1 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN10 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN11 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN12 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN13 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN14 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN15 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN2 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN3 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN4 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN5 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN6 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN7 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN8 : TBits_1; assembler; nostackframe; inline;
    function  getPTEN9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setPTEN(thebits : TBits_16); assembler; nostackframe; inline;
    procedure setPTEN0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPTEN9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearPTEN0;
    procedure clearPTEN10;
    procedure clearPTEN11;
    procedure clearPTEN12;
    procedure clearPTEN13;
    procedure clearPTEN14;
    procedure clearPTEN15;
    procedure clearPTEN1;
    procedure clearPTEN2;
    procedure clearPTEN3;
    procedure clearPTEN4;
    procedure clearPTEN5;
    procedure clearPTEN6;
    procedure clearPTEN7;
    procedure clearPTEN8;
    procedure clearPTEN9;
    procedure setPTEN0;
    procedure setPTEN10;
    procedure setPTEN11;
    procedure setPTEN12;
    procedure setPTEN13;
    procedure setPTEN14;
    procedure setPTEN15;
    procedure setPTEN1;
    procedure setPTEN2;
    procedure setPTEN3;
    procedure setPTEN4;
    procedure setPTEN5;
    procedure setPTEN6;
    procedure setPTEN7;
    procedure setPTEN8;
    procedure setPTEN9;
    property PTEN : TBits_16 read getPTEN write setPTEN;
    property PTEN0 : TBits_1 read getPTEN0 write setPTEN0;
    property PTEN1 : TBits_1 read getPTEN1 write setPTEN1;
    property PTEN10 : TBits_1 read getPTEN10 write setPTEN10;
    property PTEN11 : TBits_1 read getPTEN11 write setPTEN11;
    property PTEN12 : TBits_1 read getPTEN12 write setPTEN12;
    property PTEN13 : TBits_1 read getPTEN13 write setPTEN13;
    property PTEN14 : TBits_1 read getPTEN14 write setPTEN14;
    property PTEN15 : TBits_1 read getPTEN15 write setPTEN15;
    property PTEN2 : TBits_1 read getPTEN2 write setPTEN2;
    property PTEN3 : TBits_1 read getPTEN3 write setPTEN3;
    property PTEN4 : TBits_1 read getPTEN4 write setPTEN4;
    property PTEN5 : TBits_1 read getPTEN5 write setPTEN5;
    property PTEN6 : TBits_1 read getPTEN6 write setPTEN6;
    property PTEN7 : TBits_1 read getPTEN7 write setPTEN7;
    property PTEN8 : TBits_1 read getPTEN8 write setPTEN8;
    property PTEN9 : TBits_1 read getPTEN9 write setPTEN9;
    property w : TBits_32 read getw write setw;
  end;
  TPMP_PMSTAT = record
  private
    function  getIB0F : TBits_1; assembler; nostackframe; inline;
    function  getIB1F : TBits_1; assembler; nostackframe; inline;
    function  getIB2F : TBits_1; assembler; nostackframe; inline;
    function  getIB3F : TBits_1; assembler; nostackframe; inline;
    function  getIBF : TBits_1; assembler; nostackframe; inline;
    function  getIBOV : TBits_1; assembler; nostackframe; inline;
    function  getOB0E : TBits_1; assembler; nostackframe; inline;
    function  getOB1E : TBits_1; assembler; nostackframe; inline;
    function  getOB2E : TBits_1; assembler; nostackframe; inline;
    function  getOB3E : TBits_1; assembler; nostackframe; inline;
    function  getOBE : TBits_1; assembler; nostackframe; inline;
    function  getOBUF : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setIB0F(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIB1F(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIB2F(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIB3F(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIBF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIBOV(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOB0E(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOB1E(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOB2E(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOB3E(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOBE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOBUF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearIB0F;
    procedure clearIB1F;
    procedure clearIB2F;
    procedure clearIB3F;
    procedure clearIBF;
    procedure clearIBOV;
    procedure clearOB0E;
    procedure clearOB1E;
    procedure clearOB2E;
    procedure clearOB3E;
    procedure clearOBE;
    procedure clearOBUF;
    procedure setIB0F;
    procedure setIB1F;
    procedure setIB2F;
    procedure setIB3F;
    procedure setIBF;
    procedure setIBOV;
    procedure setOB0E;
    procedure setOB1E;
    procedure setOB2E;
    procedure setOB3E;
    procedure setOBE;
    procedure setOBUF;
    property IB0F : TBits_1 read getIB0F write setIB0F;
    property IB1F : TBits_1 read getIB1F write setIB1F;
    property IB2F : TBits_1 read getIB2F write setIB2F;
    property IB3F : TBits_1 read getIB3F write setIB3F;
    property IBF : TBits_1 read getIBF write setIBF;
    property IBOV : TBits_1 read getIBOV write setIBOV;
    property OB0E : TBits_1 read getOB0E write setOB0E;
    property OB1E : TBits_1 read getOB1E write setOB1E;
    property OB2E : TBits_1 read getOB2E write setOB2E;
    property OB3E : TBits_1 read getOB3E write setOB3E;
    property OBE : TBits_1 read getOBE write setOBE;
    property OBUF : TBits_1 read getOBUF write setOBUF;
    property w : TBits_32 read getw write setw;
  end;
type
  TPMPRegisters = record
    PMCONbits : TPMP_PMCON;
    PMCON : longWord;
    PMCONCLR : longWord;
    PMCONSET : longWord;
    PMCONINV : longWord;
    PMMODEbits : TPMP_PMMODE;
    PMMODE : longWord;
    PMMODECLR : longWord;
    PMMODESET : longWord;
    PMMODEINV : longWord;
    PMADDRbits : TPMP_PMADDR;
    PMADDR : longWord;
    PMADDRCLR : longWord;
    PMADDRSET : longWord;
    PMADDRINV : longWord;
    PMDOUTbits : TPMP_PMDOUT;
    PMDOUT : longWord;
    PMDOUTCLR : longWord;
    PMDOUTSET : longWord;
    PMDOUTINV : longWord;
    PMDINbits : TPMP_PMDIN;
    PMDIN : longWord;
    PMDINCLR : longWord;
    PMDINSET : longWord;
    PMDININV : longWord;
    PMAENbits : TPMP_PMAEN;
    PMAEN : longWord;
    PMAENCLR : longWord;
    PMAENSET : longWord;
    PMAENINV : longWord;
    PMSTATbits : TPMP_PMSTAT;
    PMSTAT : longWord;
    PMSTATCLR : longWord;
    PMSTATSET : longWord;
    PMSTATINV : longWord;
  end;
  TADC10_AD1CON1 = record
  private
    function  getADON : TBits_1; assembler; nostackframe; inline;
    function  getADSIDL : TBits_1; assembler; nostackframe; inline;
    function  getASAM : TBits_1; assembler; nostackframe; inline;
    function  getCLRASAM : TBits_1; assembler; nostackframe; inline;
    function  getDONE : TBits_1; assembler; nostackframe; inline;
    function  getFORM : TBits_3; assembler; nostackframe; inline;
    function  getFORM0 : TBits_1; assembler; nostackframe; inline;
    function  getFORM1 : TBits_1; assembler; nostackframe; inline;
    function  getFORM2 : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSAMP : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getSSRC : TBits_3; assembler; nostackframe; inline;
    function  getSSRC0 : TBits_1; assembler; nostackframe; inline;
    function  getSSRC1 : TBits_1; assembler; nostackframe; inline;
    function  getSSRC2 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setADON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setASAM(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCLRASAM(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDONE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFORM(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setFORM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFORM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFORM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSAMP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSSRC(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setSSRC0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSSRC1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSSRC2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearADON;
    procedure clearADSIDL;
    procedure clearASAM;
    procedure clearCLRASAM;
    procedure clearDONE;
    procedure clearFORM0;
    procedure clearFORM1;
    procedure clearFORM2;
    procedure clearON;
    procedure clearSAMP;
    procedure clearSIDL;
    procedure clearSSRC0;
    procedure clearSSRC1;
    procedure clearSSRC2;
    procedure setADON;
    procedure setADSIDL;
    procedure setASAM;
    procedure setCLRASAM;
    procedure setDONE;
    procedure setFORM0;
    procedure setFORM1;
    procedure setFORM2;
    procedure setON;
    procedure setSAMP;
    procedure setSIDL;
    procedure setSSRC0;
    procedure setSSRC1;
    procedure setSSRC2;
    property ADON : TBits_1 read getADON write setADON;
    property ADSIDL : TBits_1 read getADSIDL write setADSIDL;
    property ASAM : TBits_1 read getASAM write setASAM;
    property CLRASAM : TBits_1 read getCLRASAM write setCLRASAM;
    property DONE : TBits_1 read getDONE write setDONE;
    property FORM : TBits_3 read getFORM write setFORM;
    property FORM0 : TBits_1 read getFORM0 write setFORM0;
    property FORM1 : TBits_1 read getFORM1 write setFORM1;
    property FORM2 : TBits_1 read getFORM2 write setFORM2;
    property ON : TBits_1 read getON write setON;
    property SAMP : TBits_1 read getSAMP write setSAMP;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property SSRC : TBits_3 read getSSRC write setSSRC;
    property SSRC0 : TBits_1 read getSSRC0 write setSSRC0;
    property SSRC1 : TBits_1 read getSSRC1 write setSSRC1;
    property SSRC2 : TBits_1 read getSSRC2 write setSSRC2;
    property w : TBits_32 read getw write setw;
  end;
  TADC10_AD1CON2 = record
  private
    function  getALTS : TBits_1; assembler; nostackframe; inline;
    function  getBUFM : TBits_1; assembler; nostackframe; inline;
    function  getBUFS : TBits_1; assembler; nostackframe; inline;
    function  getCSCNA : TBits_1; assembler; nostackframe; inline;
    function  getOFFCAL : TBits_1; assembler; nostackframe; inline;
    function  getSMPI : TBits_4; assembler; nostackframe; inline;
    function  getSMPI0 : TBits_1; assembler; nostackframe; inline;
    function  getSMPI1 : TBits_1; assembler; nostackframe; inline;
    function  getSMPI2 : TBits_1; assembler; nostackframe; inline;
    function  getSMPI3 : TBits_1; assembler; nostackframe; inline;
    function  getVCFG : TBits_3; assembler; nostackframe; inline;
    function  getVCFG0 : TBits_1; assembler; nostackframe; inline;
    function  getVCFG1 : TBits_1; assembler; nostackframe; inline;
    function  getVCFG2 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setALTS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBUFM(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBUFS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSCNA(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOFFCAL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSMPI(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setSMPI0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSMPI1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSMPI2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSMPI3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setVCFG(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setVCFG0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setVCFG1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setVCFG2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearALTS;
    procedure clearBUFM;
    procedure clearBUFS;
    procedure clearCSCNA;
    procedure clearOFFCAL;
    procedure clearSMPI0;
    procedure clearSMPI1;
    procedure clearSMPI2;
    procedure clearSMPI3;
    procedure clearVCFG0;
    procedure clearVCFG1;
    procedure clearVCFG2;
    procedure setALTS;
    procedure setBUFM;
    procedure setBUFS;
    procedure setCSCNA;
    procedure setOFFCAL;
    procedure setSMPI0;
    procedure setSMPI1;
    procedure setSMPI2;
    procedure setSMPI3;
    procedure setVCFG0;
    procedure setVCFG1;
    procedure setVCFG2;
    property ALTS : TBits_1 read getALTS write setALTS;
    property BUFM : TBits_1 read getBUFM write setBUFM;
    property BUFS : TBits_1 read getBUFS write setBUFS;
    property CSCNA : TBits_1 read getCSCNA write setCSCNA;
    property OFFCAL : TBits_1 read getOFFCAL write setOFFCAL;
    property SMPI : TBits_4 read getSMPI write setSMPI;
    property SMPI0 : TBits_1 read getSMPI0 write setSMPI0;
    property SMPI1 : TBits_1 read getSMPI1 write setSMPI1;
    property SMPI2 : TBits_1 read getSMPI2 write setSMPI2;
    property SMPI3 : TBits_1 read getSMPI3 write setSMPI3;
    property VCFG : TBits_3 read getVCFG write setVCFG;
    property VCFG0 : TBits_1 read getVCFG0 write setVCFG0;
    property VCFG1 : TBits_1 read getVCFG1 write setVCFG1;
    property VCFG2 : TBits_1 read getVCFG2 write setVCFG2;
    property w : TBits_32 read getw write setw;
  end;
  TADC10_AD1CON3 = record
  private
    function  getADCS : TBits_8; assembler; nostackframe; inline;
    function  getADCS0 : TBits_1; assembler; nostackframe; inline;
    function  getADCS1 : TBits_1; assembler; nostackframe; inline;
    function  getADCS2 : TBits_1; assembler; nostackframe; inline;
    function  getADCS3 : TBits_1; assembler; nostackframe; inline;
    function  getADCS4 : TBits_1; assembler; nostackframe; inline;
    function  getADCS5 : TBits_1; assembler; nostackframe; inline;
    function  getADCS6 : TBits_1; assembler; nostackframe; inline;
    function  getADCS7 : TBits_1; assembler; nostackframe; inline;
    function  getADRC : TBits_1; assembler; nostackframe; inline;
    function  getSAMC : TBits_5; assembler; nostackframe; inline;
    function  getSAMC0 : TBits_1; assembler; nostackframe; inline;
    function  getSAMC1 : TBits_1; assembler; nostackframe; inline;
    function  getSAMC2 : TBits_1; assembler; nostackframe; inline;
    function  getSAMC3 : TBits_1; assembler; nostackframe; inline;
    function  getSAMC4 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setADCS(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setADCS0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADCS1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADCS2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADCS3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADCS4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADCS5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADCS6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADCS7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setADRC(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSAMC(thebits : TBits_5); assembler; nostackframe; inline;
    procedure setSAMC0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSAMC1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSAMC2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSAMC3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSAMC4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearADCS0;
    procedure clearADCS1;
    procedure clearADCS2;
    procedure clearADCS3;
    procedure clearADCS4;
    procedure clearADCS5;
    procedure clearADCS6;
    procedure clearADCS7;
    procedure clearADRC;
    procedure clearSAMC0;
    procedure clearSAMC1;
    procedure clearSAMC2;
    procedure clearSAMC3;
    procedure clearSAMC4;
    procedure setADCS0;
    procedure setADCS1;
    procedure setADCS2;
    procedure setADCS3;
    procedure setADCS4;
    procedure setADCS5;
    procedure setADCS6;
    procedure setADCS7;
    procedure setADRC;
    procedure setSAMC0;
    procedure setSAMC1;
    procedure setSAMC2;
    procedure setSAMC3;
    procedure setSAMC4;
    property ADCS : TBits_8 read getADCS write setADCS;
    property ADCS0 : TBits_1 read getADCS0 write setADCS0;
    property ADCS1 : TBits_1 read getADCS1 write setADCS1;
    property ADCS2 : TBits_1 read getADCS2 write setADCS2;
    property ADCS3 : TBits_1 read getADCS3 write setADCS3;
    property ADCS4 : TBits_1 read getADCS4 write setADCS4;
    property ADCS5 : TBits_1 read getADCS5 write setADCS5;
    property ADCS6 : TBits_1 read getADCS6 write setADCS6;
    property ADCS7 : TBits_1 read getADCS7 write setADCS7;
    property ADRC : TBits_1 read getADRC write setADRC;
    property SAMC : TBits_5 read getSAMC write setSAMC;
    property SAMC0 : TBits_1 read getSAMC0 write setSAMC0;
    property SAMC1 : TBits_1 read getSAMC1 write setSAMC1;
    property SAMC2 : TBits_1 read getSAMC2 write setSAMC2;
    property SAMC3 : TBits_1 read getSAMC3 write setSAMC3;
    property SAMC4 : TBits_1 read getSAMC4 write setSAMC4;
    property w : TBits_32 read getw write setw;
  end;
  TADC10_AD1CHS = record
  private
    function  getCH0NA : TBits_1; assembler; nostackframe; inline;
    function  getCH0NB : TBits_1; assembler; nostackframe; inline;
    function  getCH0SA : TBits_4; assembler; nostackframe; inline;
    function  getCH0SA0 : TBits_1; assembler; nostackframe; inline;
    function  getCH0SA1 : TBits_1; assembler; nostackframe; inline;
    function  getCH0SA2 : TBits_1; assembler; nostackframe; inline;
    function  getCH0SA3 : TBits_1; assembler; nostackframe; inline;
    function  getCH0SB : TBits_4; assembler; nostackframe; inline;
    function  getCH0SB0 : TBits_1; assembler; nostackframe; inline;
    function  getCH0SB1 : TBits_1; assembler; nostackframe; inline;
    function  getCH0SB2 : TBits_1; assembler; nostackframe; inline;
    function  getCH0SB3 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCH0NA(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCH0NB(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCH0SA(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setCH0SA0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCH0SA1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCH0SA2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCH0SA3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCH0SB(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setCH0SB0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCH0SB1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCH0SB2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCH0SB3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCH0NA;
    procedure clearCH0NB;
    procedure clearCH0SA0;
    procedure clearCH0SA1;
    procedure clearCH0SA2;
    procedure clearCH0SA3;
    procedure clearCH0SB0;
    procedure clearCH0SB1;
    procedure clearCH0SB2;
    procedure clearCH0SB3;
    procedure setCH0NA;
    procedure setCH0NB;
    procedure setCH0SA0;
    procedure setCH0SA1;
    procedure setCH0SA2;
    procedure setCH0SA3;
    procedure setCH0SB0;
    procedure setCH0SB1;
    procedure setCH0SB2;
    procedure setCH0SB3;
    property CH0NA : TBits_1 read getCH0NA write setCH0NA;
    property CH0NB : TBits_1 read getCH0NB write setCH0NB;
    property CH0SA : TBits_4 read getCH0SA write setCH0SA;
    property CH0SA0 : TBits_1 read getCH0SA0 write setCH0SA0;
    property CH0SA1 : TBits_1 read getCH0SA1 write setCH0SA1;
    property CH0SA2 : TBits_1 read getCH0SA2 write setCH0SA2;
    property CH0SA3 : TBits_1 read getCH0SA3 write setCH0SA3;
    property CH0SB : TBits_4 read getCH0SB write setCH0SB;
    property CH0SB0 : TBits_1 read getCH0SB0 write setCH0SB0;
    property CH0SB1 : TBits_1 read getCH0SB1 write setCH0SB1;
    property CH0SB2 : TBits_1 read getCH0SB2 write setCH0SB2;
    property CH0SB3 : TBits_1 read getCH0SB3 write setCH0SB3;
    property w : TBits_32 read getw write setw;
  end;
  TADC10_AD1CSSL = record
  private
    function  getCSSL : TBits_16; assembler; nostackframe; inline;
    function  getCSSL0 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL1 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL10 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL11 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL12 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL13 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL14 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL15 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL2 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL3 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL4 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL5 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL6 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL7 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL8 : TBits_1; assembler; nostackframe; inline;
    function  getCSSL9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCSSL(thebits : TBits_16); assembler; nostackframe; inline;
    procedure setCSSL0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCSSL9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCSSL0;
    procedure clearCSSL10;
    procedure clearCSSL11;
    procedure clearCSSL12;
    procedure clearCSSL13;
    procedure clearCSSL14;
    procedure clearCSSL15;
    procedure clearCSSL1;
    procedure clearCSSL2;
    procedure clearCSSL3;
    procedure clearCSSL4;
    procedure clearCSSL5;
    procedure clearCSSL6;
    procedure clearCSSL7;
    procedure clearCSSL8;
    procedure clearCSSL9;
    procedure setCSSL0;
    procedure setCSSL10;
    procedure setCSSL11;
    procedure setCSSL12;
    procedure setCSSL13;
    procedure setCSSL14;
    procedure setCSSL15;
    procedure setCSSL1;
    procedure setCSSL2;
    procedure setCSSL3;
    procedure setCSSL4;
    procedure setCSSL5;
    procedure setCSSL6;
    procedure setCSSL7;
    procedure setCSSL8;
    procedure setCSSL9;
    property CSSL : TBits_16 read getCSSL write setCSSL;
    property CSSL0 : TBits_1 read getCSSL0 write setCSSL0;
    property CSSL1 : TBits_1 read getCSSL1 write setCSSL1;
    property CSSL10 : TBits_1 read getCSSL10 write setCSSL10;
    property CSSL11 : TBits_1 read getCSSL11 write setCSSL11;
    property CSSL12 : TBits_1 read getCSSL12 write setCSSL12;
    property CSSL13 : TBits_1 read getCSSL13 write setCSSL13;
    property CSSL14 : TBits_1 read getCSSL14 write setCSSL14;
    property CSSL15 : TBits_1 read getCSSL15 write setCSSL15;
    property CSSL2 : TBits_1 read getCSSL2 write setCSSL2;
    property CSSL3 : TBits_1 read getCSSL3 write setCSSL3;
    property CSSL4 : TBits_1 read getCSSL4 write setCSSL4;
    property CSSL5 : TBits_1 read getCSSL5 write setCSSL5;
    property CSSL6 : TBits_1 read getCSSL6 write setCSSL6;
    property CSSL7 : TBits_1 read getCSSL7 write setCSSL7;
    property CSSL8 : TBits_1 read getCSSL8 write setCSSL8;
    property CSSL9 : TBits_1 read getCSSL9 write setCSSL9;
    property w : TBits_32 read getw write setw;
  end;
  TADC10_AD1PCFG = record
  private
    function  getPCFG : TBits_16; assembler; nostackframe; inline;
    function  getPCFG0 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG1 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG10 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG11 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG12 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG13 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG14 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG15 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG2 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG3 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG4 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG5 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG6 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG7 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG8 : TBits_1; assembler; nostackframe; inline;
    function  getPCFG9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setPCFG(thebits : TBits_16); assembler; nostackframe; inline;
    procedure setPCFG0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPCFG9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearPCFG0;
    procedure clearPCFG10;
    procedure clearPCFG11;
    procedure clearPCFG12;
    procedure clearPCFG13;
    procedure clearPCFG14;
    procedure clearPCFG15;
    procedure clearPCFG1;
    procedure clearPCFG2;
    procedure clearPCFG3;
    procedure clearPCFG4;
    procedure clearPCFG5;
    procedure clearPCFG6;
    procedure clearPCFG7;
    procedure clearPCFG8;
    procedure clearPCFG9;
    procedure setPCFG0;
    procedure setPCFG10;
    procedure setPCFG11;
    procedure setPCFG12;
    procedure setPCFG13;
    procedure setPCFG14;
    procedure setPCFG15;
    procedure setPCFG1;
    procedure setPCFG2;
    procedure setPCFG3;
    procedure setPCFG4;
    procedure setPCFG5;
    procedure setPCFG6;
    procedure setPCFG7;
    procedure setPCFG8;
    procedure setPCFG9;
    property PCFG : TBits_16 read getPCFG write setPCFG;
    property PCFG0 : TBits_1 read getPCFG0 write setPCFG0;
    property PCFG1 : TBits_1 read getPCFG1 write setPCFG1;
    property PCFG10 : TBits_1 read getPCFG10 write setPCFG10;
    property PCFG11 : TBits_1 read getPCFG11 write setPCFG11;
    property PCFG12 : TBits_1 read getPCFG12 write setPCFG12;
    property PCFG13 : TBits_1 read getPCFG13 write setPCFG13;
    property PCFG14 : TBits_1 read getPCFG14 write setPCFG14;
    property PCFG15 : TBits_1 read getPCFG15 write setPCFG15;
    property PCFG2 : TBits_1 read getPCFG2 write setPCFG2;
    property PCFG3 : TBits_1 read getPCFG3 write setPCFG3;
    property PCFG4 : TBits_1 read getPCFG4 write setPCFG4;
    property PCFG5 : TBits_1 read getPCFG5 write setPCFG5;
    property PCFG6 : TBits_1 read getPCFG6 write setPCFG6;
    property PCFG7 : TBits_1 read getPCFG7 write setPCFG7;
    property PCFG8 : TBits_1 read getPCFG8 write setPCFG8;
    property PCFG9 : TBits_1 read getPCFG9 write setPCFG9;
    property w : TBits_32 read getw write setw;
  end;
type
  TADC10Registers = record
    AD1CON1bits : TADC10_AD1CON1;
    AD1CON1 : longWord;
    AD1CON1CLR : longWord;
    AD1CON1SET : longWord;
    AD1CON1INV : longWord;
    AD1CON2bits : TADC10_AD1CON2;
    AD1CON2 : longWord;
    AD1CON2CLR : longWord;
    AD1CON2SET : longWord;
    AD1CON2INV : longWord;
    AD1CON3bits : TADC10_AD1CON3;
    AD1CON3 : longWord;
    AD1CON3CLR : longWord;
    AD1CON3SET : longWord;
    AD1CON3INV : longWord;
    AD1CHSbits : TADC10_AD1CHS;
    AD1CHS : longWord;
    AD1CHSCLR : longWord;
    AD1CHSSET : longWord;
    AD1CHSINV : longWord;
    AD1CSSLbits : TADC10_AD1CSSL;
    AD1CSSL : longWord;
    AD1CSSLCLR : longWord;
    AD1CSSLSET : longWord;
    AD1CSSLINV : longWord;
    AD1PCFGbits : TADC10_AD1PCFG;
    AD1PCFG : longWord;
    AD1PCFGCLR : longWord;
    AD1PCFGSET : longWord;
    AD1PCFGINV : longWord;
    ADC1BUF0 : longWord;
    ADC1BUF1 : longWord;
    ADC1BUF2 : longWord;
    ADC1BUF3 : longWord;
    ADC1BUF4 : longWord;
    ADC1BUF5 : longWord;
    ADC1BUF6 : longWord;
    ADC1BUF7 : longWord;
    ADC1BUF8 : longWord;
    ADC1BUF9 : longWord;
    ADC1BUFA : longWord;
    ADC1BUFB : longWord;
    ADC1BUFC : longWord;
    ADC1BUFD : longWord;
    ADC1BUFE : longWord;
    ADC1BUFF : longWord;
  end;
  TCVR_CVRCON = record
  private
    function  getCVR : TBits_4; assembler; nostackframe; inline;
    function  getCVR0 : TBits_1; assembler; nostackframe; inline;
    function  getCVR1 : TBits_1; assembler; nostackframe; inline;
    function  getCVR2 : TBits_1; assembler; nostackframe; inline;
    function  getCVR3 : TBits_1; assembler; nostackframe; inline;
    function  getCVROE : TBits_1; assembler; nostackframe; inline;
    function  getCVRR : TBits_1; assembler; nostackframe; inline;
    function  getCVRSS : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCVR(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setCVR0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCVR1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCVR2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCVR3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCVROE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCVRR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCVRSS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCVR0;
    procedure clearCVR1;
    procedure clearCVR2;
    procedure clearCVR3;
    procedure clearCVROE;
    procedure clearCVRR;
    procedure clearCVRSS;
    procedure clearON;
    procedure setCVR0;
    procedure setCVR1;
    procedure setCVR2;
    procedure setCVR3;
    procedure setCVROE;
    procedure setCVRR;
    procedure setCVRSS;
    procedure setON;
    property CVR : TBits_4 read getCVR write setCVR;
    property CVR0 : TBits_1 read getCVR0 write setCVR0;
    property CVR1 : TBits_1 read getCVR1 write setCVR1;
    property CVR2 : TBits_1 read getCVR2 write setCVR2;
    property CVR3 : TBits_1 read getCVR3 write setCVR3;
    property CVROE : TBits_1 read getCVROE write setCVROE;
    property CVRR : TBits_1 read getCVRR write setCVRR;
    property CVRSS : TBits_1 read getCVRSS write setCVRSS;
    property ON : TBits_1 read getON write setON;
    property w : TBits_32 read getw write setw;
  end;
type
  TCVRRegisters = record
    CVRCONbits : TCVR_CVRCON;
    CVRCON : longWord;
    CVRCONCLR : longWord;
    CVRCONSET : longWord;
    CVRCONINV : longWord;
  end;
  TCMP_CM1CON = record
  private
    function  getCCH : TBits_2; assembler; nostackframe; inline;
    function  getCCH0 : TBits_1; assembler; nostackframe; inline;
    function  getCCH1 : TBits_1; assembler; nostackframe; inline;
    function  getCOE : TBits_1; assembler; nostackframe; inline;
    function  getCOUT : TBits_1; assembler; nostackframe; inline;
    function  getCPOL : TBits_1; assembler; nostackframe; inline;
    function  getCREF : TBits_1; assembler; nostackframe; inline;
    function  getEVPOL : TBits_2; assembler; nostackframe; inline;
    function  getEVPOL0 : TBits_1; assembler; nostackframe; inline;
    function  getEVPOL1 : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCCH(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setCCH0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCCH1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCOE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCOUT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCPOL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCREF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setEVPOL(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setEVPOL0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setEVPOL1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCCH0;
    procedure clearCCH1;
    procedure clearCOE;
    procedure clearCOUT;
    procedure clearCPOL;
    procedure clearCREF;
    procedure clearEVPOL0;
    procedure clearEVPOL1;
    procedure clearON;
    procedure setCCH0;
    procedure setCCH1;
    procedure setCOE;
    procedure setCOUT;
    procedure setCPOL;
    procedure setCREF;
    procedure setEVPOL0;
    procedure setEVPOL1;
    procedure setON;
    property CCH : TBits_2 read getCCH write setCCH;
    property CCH0 : TBits_1 read getCCH0 write setCCH0;
    property CCH1 : TBits_1 read getCCH1 write setCCH1;
    property COE : TBits_1 read getCOE write setCOE;
    property COUT : TBits_1 read getCOUT write setCOUT;
    property CPOL : TBits_1 read getCPOL write setCPOL;
    property CREF : TBits_1 read getCREF write setCREF;
    property EVPOL : TBits_2 read getEVPOL write setEVPOL;
    property EVPOL0 : TBits_1 read getEVPOL0 write setEVPOL0;
    property EVPOL1 : TBits_1 read getEVPOL1 write setEVPOL1;
    property ON : TBits_1 read getON write setON;
    property w : TBits_32 read getw write setw;
  end;
  TCMP_CM2CON = record
  private
    function  getCCH : TBits_2; assembler; nostackframe; inline;
    function  getCCH0 : TBits_1; assembler; nostackframe; inline;
    function  getCCH1 : TBits_1; assembler; nostackframe; inline;
    function  getCOE : TBits_1; assembler; nostackframe; inline;
    function  getCOUT : TBits_1; assembler; nostackframe; inline;
    function  getCPOL : TBits_1; assembler; nostackframe; inline;
    function  getCREF : TBits_1; assembler; nostackframe; inline;
    function  getEVPOL : TBits_2; assembler; nostackframe; inline;
    function  getEVPOL0 : TBits_1; assembler; nostackframe; inline;
    function  getEVPOL1 : TBits_1; assembler; nostackframe; inline;
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCCH(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setCCH0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCCH1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCOE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCOUT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCPOL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCREF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setEVPOL(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setEVPOL0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setEVPOL1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCCH0;
    procedure clearCCH1;
    procedure clearCOE;
    procedure clearCOUT;
    procedure clearCPOL;
    procedure clearCREF;
    procedure clearEVPOL0;
    procedure clearEVPOL1;
    procedure clearON;
    procedure setCCH0;
    procedure setCCH1;
    procedure setCOE;
    procedure setCOUT;
    procedure setCPOL;
    procedure setCREF;
    procedure setEVPOL0;
    procedure setEVPOL1;
    procedure setON;
    property CCH : TBits_2 read getCCH write setCCH;
    property CCH0 : TBits_1 read getCCH0 write setCCH0;
    property CCH1 : TBits_1 read getCCH1 write setCCH1;
    property COE : TBits_1 read getCOE write setCOE;
    property COUT : TBits_1 read getCOUT write setCOUT;
    property CPOL : TBits_1 read getCPOL write setCPOL;
    property CREF : TBits_1 read getCREF write setCREF;
    property EVPOL : TBits_2 read getEVPOL write setEVPOL;
    property EVPOL0 : TBits_1 read getEVPOL0 write setEVPOL0;
    property EVPOL1 : TBits_1 read getEVPOL1 write setEVPOL1;
    property ON : TBits_1 read getON write setON;
    property w : TBits_32 read getw write setw;
  end;
  TCMP_CMSTAT = record
  private
    function  getC1OUT : TBits_1; assembler; nostackframe; inline;
    function  getC2OUT : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setC1OUT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setC2OUT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearC1OUT;
    procedure clearC2OUT;
    procedure clearSIDL;
    procedure setC1OUT;
    procedure setC2OUT;
    procedure setSIDL;
    property C1OUT : TBits_1 read getC1OUT write setC1OUT;
    property C2OUT : TBits_1 read getC2OUT write setC2OUT;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
type
  TCMPRegisters = record
    CM1CONbits : TCMP_CM1CON;
    CM1CON : longWord;
    CM1CONCLR : longWord;
    CM1CONSET : longWord;
    CM1CONINV : longWord;
    CM2CONbits : TCMP_CM2CON;
    CM2CON : longWord;
    CM2CONCLR : longWord;
    CM2CONSET : longWord;
    CM2CONINV : longWord;
    CMSTATbits : TCMP_CMSTAT;
    CMSTAT : longWord;
    CMSTATCLR : longWord;
    CMSTATSET : longWord;
    CMSTATINV : longWord;
  end;
  TOSC_OSCCON = record
  private
    function  getCF : TBits_1; assembler; nostackframe; inline;
    function  getCLKLOCK : TBits_1; assembler; nostackframe; inline;
    function  getCOSC : TBits_3; assembler; nostackframe; inline;
    function  getCOSC0 : TBits_1; assembler; nostackframe; inline;
    function  getCOSC1 : TBits_1; assembler; nostackframe; inline;
    function  getCOSC2 : TBits_1; assembler; nostackframe; inline;
    function  getFRCDIV : TBits_3; assembler; nostackframe; inline;
    function  getFRCDIV0 : TBits_1; assembler; nostackframe; inline;
    function  getFRCDIV1 : TBits_1; assembler; nostackframe; inline;
    function  getFRCDIV2 : TBits_1; assembler; nostackframe; inline;
    function  getLOCK : TBits_1; assembler; nostackframe; inline;
    function  getNOSC : TBits_3; assembler; nostackframe; inline;
    function  getNOSC0 : TBits_1; assembler; nostackframe; inline;
    function  getNOSC1 : TBits_1; assembler; nostackframe; inline;
    function  getNOSC2 : TBits_1; assembler; nostackframe; inline;
    function  getOSWEN : TBits_1; assembler; nostackframe; inline;
    function  getPBDIV : TBits_2; assembler; nostackframe; inline;
    function  getPBDIV0 : TBits_1; assembler; nostackframe; inline;
    function  getPBDIV1 : TBits_1; assembler; nostackframe; inline;
    function  getPLLMULT : TBits_3; assembler; nostackframe; inline;
    function  getPLLMULT0 : TBits_1; assembler; nostackframe; inline;
    function  getPLLMULT1 : TBits_1; assembler; nostackframe; inline;
    function  getPLLMULT2 : TBits_1; assembler; nostackframe; inline;
    function  getPLLODIV : TBits_3; assembler; nostackframe; inline;
    function  getPLLODIV0 : TBits_1; assembler; nostackframe; inline;
    function  getPLLODIV1 : TBits_1; assembler; nostackframe; inline;
    function  getPLLODIV2 : TBits_1; assembler; nostackframe; inline;
    function  getSLPEN : TBits_1; assembler; nostackframe; inline;
    function  getSOSCEN : TBits_1; assembler; nostackframe; inline;
    function  getSOSCRDY : TBits_1; assembler; nostackframe; inline;
    function  getUFRCEN : TBits_1; assembler; nostackframe; inline;
    function  getULOCK : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCLKLOCK(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCOSC(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setCOSC0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCOSC1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCOSC2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRCDIV(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setFRCDIV0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRCDIV1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRCDIV2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLOCK(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setNOSC(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setNOSC0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setNOSC1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setNOSC2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOSWEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPBDIV(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setPBDIV0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPBDIV1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPLLMULT(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setPLLMULT0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPLLMULT1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPLLMULT2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPLLODIV(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setPLLODIV0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPLLODIV1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPLLODIV2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSLPEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSOSCEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSOSCRDY(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUFRCEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setULOCK(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCF;
    procedure clearCLKLOCK;
    procedure clearCOSC0;
    procedure clearCOSC1;
    procedure clearCOSC2;
    procedure clearFRCDIV0;
    procedure clearFRCDIV1;
    procedure clearFRCDIV2;
    procedure clearLOCK;
    procedure clearNOSC0;
    procedure clearNOSC1;
    procedure clearNOSC2;
    procedure clearOSWEN;
    procedure clearPBDIV0;
    procedure clearPBDIV1;
    procedure clearPLLMULT0;
    procedure clearPLLMULT1;
    procedure clearPLLMULT2;
    procedure clearPLLODIV0;
    procedure clearPLLODIV1;
    procedure clearPLLODIV2;
    procedure clearSLPEN;
    procedure clearSOSCEN;
    procedure clearSOSCRDY;
    procedure clearUFRCEN;
    procedure clearULOCK;
    procedure setCF;
    procedure setCLKLOCK;
    procedure setCOSC0;
    procedure setCOSC1;
    procedure setCOSC2;
    procedure setFRCDIV0;
    procedure setFRCDIV1;
    procedure setFRCDIV2;
    procedure setLOCK;
    procedure setNOSC0;
    procedure setNOSC1;
    procedure setNOSC2;
    procedure setOSWEN;
    procedure setPBDIV0;
    procedure setPBDIV1;
    procedure setPLLMULT0;
    procedure setPLLMULT1;
    procedure setPLLMULT2;
    procedure setPLLODIV0;
    procedure setPLLODIV1;
    procedure setPLLODIV2;
    procedure setSLPEN;
    procedure setSOSCEN;
    procedure setSOSCRDY;
    procedure setUFRCEN;
    procedure setULOCK;
    property CF : TBits_1 read getCF write setCF;
    property CLKLOCK : TBits_1 read getCLKLOCK write setCLKLOCK;
    property COSC : TBits_3 read getCOSC write setCOSC;
    property COSC0 : TBits_1 read getCOSC0 write setCOSC0;
    property COSC1 : TBits_1 read getCOSC1 write setCOSC1;
    property COSC2 : TBits_1 read getCOSC2 write setCOSC2;
    property FRCDIV : TBits_3 read getFRCDIV write setFRCDIV;
    property FRCDIV0 : TBits_1 read getFRCDIV0 write setFRCDIV0;
    property FRCDIV1 : TBits_1 read getFRCDIV1 write setFRCDIV1;
    property FRCDIV2 : TBits_1 read getFRCDIV2 write setFRCDIV2;
    property LOCK : TBits_1 read getLOCK write setLOCK;
    property NOSC : TBits_3 read getNOSC write setNOSC;
    property NOSC0 : TBits_1 read getNOSC0 write setNOSC0;
    property NOSC1 : TBits_1 read getNOSC1 write setNOSC1;
    property NOSC2 : TBits_1 read getNOSC2 write setNOSC2;
    property OSWEN : TBits_1 read getOSWEN write setOSWEN;
    property PBDIV : TBits_2 read getPBDIV write setPBDIV;
    property PBDIV0 : TBits_1 read getPBDIV0 write setPBDIV0;
    property PBDIV1 : TBits_1 read getPBDIV1 write setPBDIV1;
    property PLLMULT : TBits_3 read getPLLMULT write setPLLMULT;
    property PLLMULT0 : TBits_1 read getPLLMULT0 write setPLLMULT0;
    property PLLMULT1 : TBits_1 read getPLLMULT1 write setPLLMULT1;
    property PLLMULT2 : TBits_1 read getPLLMULT2 write setPLLMULT2;
    property PLLODIV : TBits_3 read getPLLODIV write setPLLODIV;
    property PLLODIV0 : TBits_1 read getPLLODIV0 write setPLLODIV0;
    property PLLODIV1 : TBits_1 read getPLLODIV1 write setPLLODIV1;
    property PLLODIV2 : TBits_1 read getPLLODIV2 write setPLLODIV2;
    property SLPEN : TBits_1 read getSLPEN write setSLPEN;
    property SOSCEN : TBits_1 read getSOSCEN write setSOSCEN;
    property SOSCRDY : TBits_1 read getSOSCRDY write setSOSCRDY;
    property UFRCEN : TBits_1 read getUFRCEN write setUFRCEN;
    property ULOCK : TBits_1 read getULOCK write setULOCK;
    property w : TBits_32 read getw write setw;
  end;
  TOSC_OSCTUN = record
  private
    function  getTUN : TBits_6; assembler; nostackframe; inline;
    function  getTUN0 : TBits_1; assembler; nostackframe; inline;
    function  getTUN1 : TBits_1; assembler; nostackframe; inline;
    function  getTUN2 : TBits_1; assembler; nostackframe; inline;
    function  getTUN3 : TBits_1; assembler; nostackframe; inline;
    function  getTUN4 : TBits_1; assembler; nostackframe; inline;
    function  getTUN5 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setTUN(thebits : TBits_6); assembler; nostackframe; inline;
    procedure setTUN0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTUN1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTUN2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTUN3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTUN4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTUN5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearTUN0;
    procedure clearTUN1;
    procedure clearTUN2;
    procedure clearTUN3;
    procedure clearTUN4;
    procedure clearTUN5;
    procedure setTUN0;
    procedure setTUN1;
    procedure setTUN2;
    procedure setTUN3;
    procedure setTUN4;
    procedure setTUN5;
    property TUN : TBits_6 read getTUN write setTUN;
    property TUN0 : TBits_1 read getTUN0 write setTUN0;
    property TUN1 : TBits_1 read getTUN1 write setTUN1;
    property TUN2 : TBits_1 read getTUN2 write setTUN2;
    property TUN3 : TBits_1 read getTUN3 write setTUN3;
    property TUN4 : TBits_1 read getTUN4 write setTUN4;
    property TUN5 : TBits_1 read getTUN5 write setTUN5;
    property w : TBits_32 read getw write setw;
  end;
type
  TOSCRegisters = record
    OSCCONbits : TOSC_OSCCON;
    OSCCON : longWord;
    OSCCONCLR : longWord;
    OSCCONSET : longWord;
    OSCCONINV : longWord;
    OSCTUNbits : TOSC_OSCTUN;
    OSCTUN : longWord;
    OSCTUNCLR : longWord;
    OSCTUNSET : longWord;
    OSCTUNINV : longWord;
  end;
type
  TCFGRegisters = record
    DDPCON : longWord;
    DEVID : longWord;
    SYSKEY : longWord;
    SYSKEYCLR : longWord;
    SYSKEYSET : longWord;
    SYSKEYINV : longWord;
  end;
  TNVM_NVMCON = record
  private
    function  getLVDERR : TBits_1; assembler; nostackframe; inline;
    function  getLVDSTAT : TBits_1; assembler; nostackframe; inline;
    function  getNVMOP : TBits_4; assembler; nostackframe; inline;
    function  getNVMOP0 : TBits_1; assembler; nostackframe; inline;
    function  getNVMOP1 : TBits_1; assembler; nostackframe; inline;
    function  getNVMOP2 : TBits_1; assembler; nostackframe; inline;
    function  getNVMOP3 : TBits_1; assembler; nostackframe; inline;
    function  getPROGOP : TBits_4; assembler; nostackframe; inline;
    function  getPROGOP0 : TBits_1; assembler; nostackframe; inline;
    function  getPROGOP1 : TBits_1; assembler; nostackframe; inline;
    function  getPROGOP2 : TBits_1; assembler; nostackframe; inline;
    function  getPROGOP3 : TBits_1; assembler; nostackframe; inline;
    function  getWR : TBits_1; assembler; nostackframe; inline;
    function  getWREN : TBits_1; assembler; nostackframe; inline;
    function  getWRERR : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setLVDERR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLVDSTAT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setNVMOP(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setNVMOP0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setNVMOP1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setNVMOP2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setNVMOP3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPROGOP(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setPROGOP0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPROGOP1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPROGOP2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPROGOP3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWREN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWRERR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearLVDERR;
    procedure clearLVDSTAT;
    procedure clearNVMOP0;
    procedure clearNVMOP1;
    procedure clearNVMOP2;
    procedure clearNVMOP3;
    procedure clearPROGOP0;
    procedure clearPROGOP1;
    procedure clearPROGOP2;
    procedure clearPROGOP3;
    procedure clearWR;
    procedure clearWREN;
    procedure clearWRERR;
    procedure setLVDERR;
    procedure setLVDSTAT;
    procedure setNVMOP0;
    procedure setNVMOP1;
    procedure setNVMOP2;
    procedure setNVMOP3;
    procedure setPROGOP0;
    procedure setPROGOP1;
    procedure setPROGOP2;
    procedure setPROGOP3;
    procedure setWR;
    procedure setWREN;
    procedure setWRERR;
    property LVDERR : TBits_1 read getLVDERR write setLVDERR;
    property LVDSTAT : TBits_1 read getLVDSTAT write setLVDSTAT;
    property NVMOP : TBits_4 read getNVMOP write setNVMOP;
    property NVMOP0 : TBits_1 read getNVMOP0 write setNVMOP0;
    property NVMOP1 : TBits_1 read getNVMOP1 write setNVMOP1;
    property NVMOP2 : TBits_1 read getNVMOP2 write setNVMOP2;
    property NVMOP3 : TBits_1 read getNVMOP3 write setNVMOP3;
    property PROGOP : TBits_4 read getPROGOP write setPROGOP;
    property PROGOP0 : TBits_1 read getPROGOP0 write setPROGOP0;
    property PROGOP1 : TBits_1 read getPROGOP1 write setPROGOP1;
    property PROGOP2 : TBits_1 read getPROGOP2 write setPROGOP2;
    property PROGOP3 : TBits_1 read getPROGOP3 write setPROGOP3;
    property WR : TBits_1 read getWR write setWR;
    property WREN : TBits_1 read getWREN write setWREN;
    property WRERR : TBits_1 read getWRERR write setWRERR;
    property w : TBits_32 read getw write setw;
  end;
type
  TNVMRegisters = record
    NVMCONbits : TNVM_NVMCON;
    NVMCON : longWord;
    NVMCONCLR : longWord;
    NVMCONSET : longWord;
    NVMCONINV : longWord;
    NVMKEY : longWord;
    NVMADDR : longWord;
    NVMADDRCLR : longWord;
    NVMADDRSET : longWord;
    NVMADDRINV : longWord;
    NVMDATA : longWord;
    NVMSRCADDR : longWord;
  end;
  TRCON_RCON = record
  private
    function  getBOR : TBits_1; assembler; nostackframe; inline;
    function  getCMR : TBits_1; assembler; nostackframe; inline;
    function  getEXTR : TBits_1; assembler; nostackframe; inline;
    function  getIDLE : TBits_1; assembler; nostackframe; inline;
    function  getPOR : TBits_1; assembler; nostackframe; inline;
    function  getSLEEP : TBits_1; assembler; nostackframe; inline;
    function  getSWR : TBits_1; assembler; nostackframe; inline;
    function  getVREGS : TBits_1; assembler; nostackframe; inline;
    function  getWDTO : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setBOR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCMR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setEXTR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIDLE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPOR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSLEEP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSWR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setVREGS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setWDTO(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearBOR;
    procedure clearCMR;
    procedure clearEXTR;
    procedure clearIDLE;
    procedure clearPOR;
    procedure clearSLEEP;
    procedure clearSWR;
    procedure clearVREGS;
    procedure clearWDTO;
    procedure setBOR;
    procedure setCMR;
    procedure setEXTR;
    procedure setIDLE;
    procedure setPOR;
    procedure setSLEEP;
    procedure setSWR;
    procedure setVREGS;
    procedure setWDTO;
    property BOR : TBits_1 read getBOR write setBOR;
    property CMR : TBits_1 read getCMR write setCMR;
    property EXTR : TBits_1 read getEXTR write setEXTR;
    property IDLE : TBits_1 read getIDLE write setIDLE;
    property POR : TBits_1 read getPOR write setPOR;
    property SLEEP : TBits_1 read getSLEEP write setSLEEP;
    property SWR : TBits_1 read getSWR write setSWR;
    property VREGS : TBits_1 read getVREGS write setVREGS;
    property WDTO : TBits_1 read getWDTO write setWDTO;
    property w : TBits_32 read getw write setw;
  end;
  TRCON_RSWRST = record
  private
    function  getSWRST : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setSWRST(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearSWRST;
    procedure setSWRST;
    property SWRST : TBits_1 read getSWRST write setSWRST;
    property w : TBits_32 read getw write setw;
  end;
type
  TRCONRegisters = record
    RCONbits : TRCON_RCON;
    RCON : longWord;
    RCONCLR : longWord;
    RCONSET : longWord;
    RCONINV : longWord;
    RSWRSTbits : TRCON_RSWRST;
    RSWRST : longWord;
    RSWRSTCLR : longWord;
    RSWRSTSET : longWord;
    RSWRSTINV : longWord;
  end;
type
  T_DDPSTATRegisters = record
    _DDPSTAT : longWord;
  end;
type
  T_STRORegisters = record
    _STRO : longWord;
    _STROCLR : longWord;
    _STROSET : longWord;
    _STROINV : longWord;
  end;
type
  T_APPORegisters = record
    _APPO : longWord;
    _APPOCLR : longWord;
    _APPOSET : longWord;
    _APPOINV : longWord;
  end;
type
  T_APPIRegisters = record
    _APPI : longWord;
  end;
  TINT_INTSTAT = record
  private
    function  getRIPL : TBits_3; assembler; nostackframe; inline;
    function  getSRIPL : TBits_3; assembler; nostackframe; inline;
    function  getVEC : TBits_6; assembler; nostackframe; inline;
    procedure setRIPL(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setSRIPL(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setVEC(thebits : TBits_6); assembler; nostackframe; inline;
  public
    property RIPL : TBits_3 read getRIPL write setRIPL;
    property SRIPL : TBits_3 read getSRIPL write setSRIPL;
    property VEC : TBits_6 read getVEC write setVEC;
  end;
type
  TINTRegisters = record
    INTCON : longWord;
    INTCONCLR : longWord;
    INTCONSET : longWord;
    INTCONINV : longWord;
    INTSTATbits : TINT_INTSTAT;
    INTSTAT : longWord;
    IPTMR : longWord;
    IPTMRCLR : longWord;
    IPTMRSET : longWord;
    IPTMRINV : longWord;
    IFS0 : longWord;
    IFS0CLR : longWord;
    IFS0SET : longWord;
    IFS0INV : longWord;
    IFS1 : longWord;
    IFS1CLR : longWord;
    IFS1SET : longWord;
    IFS1INV : longWord;
    IEC0 : longWord;
    IEC0CLR : longWord;
    IEC0SET : longWord;
    IEC0INV : longWord;
    IEC1 : longWord;
    IEC1CLR : longWord;
    IEC1SET : longWord;
    IEC1INV : longWord;
    IPC0 : longWord;
    IPC0CLR : longWord;
    IPC0SET : longWord;
    IPC0INV : longWord;
    IPC1 : longWord;
    IPC1CLR : longWord;
    IPC1SET : longWord;
    IPC1INV : longWord;
    IPC2 : longWord;
    IPC2CLR : longWord;
    IPC2SET : longWord;
    IPC2INV : longWord;
    IPC3 : longWord;
    IPC3CLR : longWord;
    IPC3SET : longWord;
    IPC3INV : longWord;
    IPC4 : longWord;
    IPC4CLR : longWord;
    IPC4SET : longWord;
    IPC4INV : longWord;
    IPC5 : longWord;
    IPC5CLR : longWord;
    IPC5SET : longWord;
    IPC5INV : longWord;
    IPC6 : longWord;
    IPC6CLR : longWord;
    IPC6SET : longWord;
    IPC6INV : longWord;
    IPC7 : longWord;
    IPC7CLR : longWord;
    IPC7SET : longWord;
    IPC7INV : longWord;
    IPC8 : longWord;
    IPC8CLR : longWord;
    IPC8SET : longWord;
    IPC8INV : longWord;
    IPC9 : longWord;
    IPC9CLR : longWord;
    IPC9SET : longWord;
    IPC9INV : longWord;
    IPC11 : longWord;
    IPC11CLR : longWord;
    IPC11SET : longWord;
    IPC11INV : longWord;
  end;
  TBMX_BMXCON = record
  private
    function  getBMXARB : TBits_3; assembler; nostackframe; inline;
    function  getBMXCHEDMA : TBits_1; assembler; nostackframe; inline;
    function  getBMXERRDMA : TBits_1; assembler; nostackframe; inline;
    function  getBMXERRDS : TBits_1; assembler; nostackframe; inline;
    function  getBMXERRICD : TBits_1; assembler; nostackframe; inline;
    function  getBMXERRIS : TBits_1; assembler; nostackframe; inline;
    function  getBMXERRIXI : TBits_1; assembler; nostackframe; inline;
    function  getBMXWSDRM : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setBMXARB(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setBMXCHEDMA(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBMXERRDMA(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBMXERRDS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBMXERRICD(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBMXERRIS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBMXERRIXI(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBMXWSDRM(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearBMXCHEDMA;
    procedure clearBMXERRDMA;
    procedure clearBMXERRDS;
    procedure clearBMXERRICD;
    procedure clearBMXERRIS;
    procedure clearBMXERRIXI;
    procedure clearBMXWSDRM;
    procedure setBMXCHEDMA;
    procedure setBMXERRDMA;
    procedure setBMXERRDS;
    procedure setBMXERRICD;
    procedure setBMXERRIS;
    procedure setBMXERRIXI;
    procedure setBMXWSDRM;
    property BMXARB : TBits_3 read getBMXARB write setBMXARB;
    property BMXCHEDMA : TBits_1 read getBMXCHEDMA write setBMXCHEDMA;
    property BMXERRDMA : TBits_1 read getBMXERRDMA write setBMXERRDMA;
    property BMXERRDS : TBits_1 read getBMXERRDS write setBMXERRDS;
    property BMXERRICD : TBits_1 read getBMXERRICD write setBMXERRICD;
    property BMXERRIS : TBits_1 read getBMXERRIS write setBMXERRIS;
    property BMXERRIXI : TBits_1 read getBMXERRIXI write setBMXERRIXI;
    property BMXWSDRM : TBits_1 read getBMXWSDRM write setBMXWSDRM;
    property w : TBits_32 read getw write setw;
  end;
type
  TBMXRegisters = record
    BMXCONbits : TBMX_BMXCON;
    BMXCON : longWord;
    BMXCONCLR : longWord;
    BMXCONSET : longWord;
    BMXCONINV : longWord;
    BMXDKPBA : longWord;
    BMXDKPBACLR : longWord;
    BMXDKPBASET : longWord;
    BMXDKPBAINV : longWord;
    BMXDUDBA : longWord;
    BMXDUDBACLR : longWord;
    BMXDUDBASET : longWord;
    BMXDUDBAINV : longWord;
    BMXDUPBA : longWord;
    BMXDUPBACLR : longWord;
    BMXDUPBASET : longWord;
    BMXDUPBAINV : longWord;
    BMXDRMSZ : longWord;
    BMXPUPBA : longWord;
    BMXPUPBACLR : longWord;
    BMXPUPBASET : longWord;
    BMXPUPBAINV : longWord;
    BMXPFMSZ : longWord;
    BMXBOOTSZ : longWord;
  end;
  TDMAC_DMACON = record
  private
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getSUSPEND : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSUSPEND(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearON;
    procedure clearSIDL;
    procedure clearSUSPEND;
    procedure setON;
    procedure setSIDL;
    procedure setSUSPEND;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property SUSPEND : TBits_1 read getSUSPEND write setSUSPEND;
    property w : TBits_32 read getw write setw;
  end;
  TDMAC_DMASTAT = record
  private
    function  getDMACH : TBits_2; assembler; nostackframe; inline;
    function  getRDWR : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setDMACH(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setRDWR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearRDWR;
    procedure setRDWR;
    property DMACH : TBits_2 read getDMACH write setDMACH;
    property RDWR : TBits_1 read getRDWR write setRDWR;
    property w : TBits_32 read getw write setw;
  end;
  TDMAC_DCRCCON = record
  private
    function  getBITO : TBits_1; assembler; nostackframe; inline;
    function  getBYTO : TBits_2; assembler; nostackframe; inline;
    function  getCRCAPP : TBits_1; assembler; nostackframe; inline;
    function  getCRCCH : TBits_2; assembler; nostackframe; inline;
    function  getCRCEN : TBits_1; assembler; nostackframe; inline;
    function  getCRCTYP : TBits_1; assembler; nostackframe; inline;
    function  getPLEN : TBits_4; assembler; nostackframe; inline;
    function  getWBO : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setBITO(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBYTO(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setCRCAPP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCRCCH(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setCRCEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCRCTYP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPLEN(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setWBO(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearBITO;
    procedure clearCRCAPP;
    procedure clearCRCEN;
    procedure clearCRCTYP;
    procedure clearWBO;
    procedure setBITO;
    procedure setCRCAPP;
    procedure setCRCEN;
    procedure setCRCTYP;
    procedure setWBO;
    property BITO : TBits_1 read getBITO write setBITO;
    property BYTO : TBits_2 read getBYTO write setBYTO;
    property CRCAPP : TBits_1 read getCRCAPP write setCRCAPP;
    property CRCCH : TBits_2 read getCRCCH write setCRCCH;
    property CRCEN : TBits_1 read getCRCEN write setCRCEN;
    property CRCTYP : TBits_1 read getCRCTYP write setCRCTYP;
    property PLEN : TBits_4 read getPLEN write setPLEN;
    property WBO : TBits_1 read getWBO write setWBO;
    property w : TBits_32 read getw write setw;
  end;
type
  TDMACRegisters = record
    DMACONbits : TDMAC_DMACON;
    DMACON : longWord;
    DMACONCLR : longWord;
    DMACONSET : longWord;
    DMACONINV : longWord;
    DMASTATbits : TDMAC_DMASTAT;
    DMASTAT : longWord;
    DMASTATCLR : longWord;
    DMASTATSET : longWord;
    DMASTATINV : longWord;
    DMAADDR : longWord;
    DMAADDRCLR : longWord;
    DMAADDRSET : longWord;
    DMAADDRINV : longWord;
    DCRCCONbits : TDMAC_DCRCCON;
    DCRCCON : longWord;
    DCRCCONCLR : longWord;
    DCRCCONSET : longWord;
    DCRCCONINV : longWord;
    DCRCDATA : longWord;
    DCRCDATACLR : longWord;
    DCRCDATASET : longWord;
    DCRCDATAINV : longWord;
    DCRCXOR : longWord;
    DCRCXORCLR : longWord;
    DCRCXORSET : longWord;
    DCRCXORINV : longWord;
  end;
  TDMAC0_DCH0CON = record
  private
    function  getCHAED : TBits_1; assembler; nostackframe; inline;
    function  getCHAEN : TBits_1; assembler; nostackframe; inline;
    function  getCHCHN : TBits_1; assembler; nostackframe; inline;
    function  getCHCHNS : TBits_1; assembler; nostackframe; inline;
    function  getCHEDET : TBits_1; assembler; nostackframe; inline;
    function  getCHEN : TBits_1; assembler; nostackframe; inline;
    function  getCHPRI : TBits_2; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCHAED(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHAEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCHN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCHNS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHEDET(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHPRI(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCHAED;
    procedure clearCHAEN;
    procedure clearCHCHN;
    procedure clearCHCHNS;
    procedure clearCHEDET;
    procedure clearCHEN;
    procedure setCHAED;
    procedure setCHAEN;
    procedure setCHCHN;
    procedure setCHCHNS;
    procedure setCHEDET;
    procedure setCHEN;
    property CHAED : TBits_1 read getCHAED write setCHAED;
    property CHAEN : TBits_1 read getCHAEN write setCHAEN;
    property CHCHN : TBits_1 read getCHCHN write setCHCHN;
    property CHCHNS : TBits_1 read getCHCHNS write setCHCHNS;
    property CHEDET : TBits_1 read getCHEDET write setCHEDET;
    property CHEN : TBits_1 read getCHEN write setCHEN;
    property CHPRI : TBits_2 read getCHPRI write setCHPRI;
    property w : TBits_32 read getw write setw;
  end;
  TDMAC0_DCH0ECON = record
  private
    function  getAIRQEN : TBits_1; assembler; nostackframe; inline;
    function  getCABORT : TBits_1; assembler; nostackframe; inline;
    function  getCFORCE : TBits_1; assembler; nostackframe; inline;
    function  getCHAIRQ : TBits_8; assembler; nostackframe; inline;
    function  getCHSIRQ : TBits_8; assembler; nostackframe; inline;
    function  getPATEN : TBits_1; assembler; nostackframe; inline;
    function  getSIRQEN : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setAIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCABORT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCFORCE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHAIRQ(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setCHSIRQ(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setPATEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearAIRQEN;
    procedure clearCABORT;
    procedure clearCFORCE;
    procedure clearPATEN;
    procedure clearSIRQEN;
    procedure setAIRQEN;
    procedure setCABORT;
    procedure setCFORCE;
    procedure setPATEN;
    procedure setSIRQEN;
    property AIRQEN : TBits_1 read getAIRQEN write setAIRQEN;
    property CABORT : TBits_1 read getCABORT write setCABORT;
    property CFORCE : TBits_1 read getCFORCE write setCFORCE;
    property CHAIRQ : TBits_8 read getCHAIRQ write setCHAIRQ;
    property CHSIRQ : TBits_8 read getCHSIRQ write setCHSIRQ;
    property PATEN : TBits_1 read getPATEN write setPATEN;
    property SIRQEN : TBits_1 read getSIRQEN write setSIRQEN;
    property w : TBits_32 read getw write setw;
  end;
  TDMAC0_DCH0INT = record
  private
    function  getCHBCIE : TBits_1; assembler; nostackframe; inline;
    function  getCHBCIF : TBits_1; assembler; nostackframe; inline;
    function  getCHCCIE : TBits_1; assembler; nostackframe; inline;
    function  getCHCCIF : TBits_1; assembler; nostackframe; inline;
    function  getCHDDIE : TBits_1; assembler; nostackframe; inline;
    function  getCHDDIF : TBits_1; assembler; nostackframe; inline;
    function  getCHDHIE : TBits_1; assembler; nostackframe; inline;
    function  getCHDHIF : TBits_1; assembler; nostackframe; inline;
    function  getCHERIE : TBits_1; assembler; nostackframe; inline;
    function  getCHERIF : TBits_1; assembler; nostackframe; inline;
    function  getCHSDIE : TBits_1; assembler; nostackframe; inline;
    function  getCHSDIF : TBits_1; assembler; nostackframe; inline;
    function  getCHSHIE : TBits_1; assembler; nostackframe; inline;
    function  getCHSHIF : TBits_1; assembler; nostackframe; inline;
    function  getCHTAIE : TBits_1; assembler; nostackframe; inline;
    function  getCHTAIF : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCHBCIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHBCIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCCIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCCIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDDIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDDIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDHIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDHIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHERIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHERIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSDIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSDIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSHIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSHIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHTAIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHTAIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCHBCIE;
    procedure clearCHBCIF;
    procedure clearCHCCIE;
    procedure clearCHCCIF;
    procedure clearCHDDIE;
    procedure clearCHDDIF;
    procedure clearCHDHIE;
    procedure clearCHDHIF;
    procedure clearCHERIE;
    procedure clearCHERIF;
    procedure clearCHSDIE;
    procedure clearCHSDIF;
    procedure clearCHSHIE;
    procedure clearCHSHIF;
    procedure clearCHTAIE;
    procedure clearCHTAIF;
    procedure setCHBCIE;
    procedure setCHBCIF;
    procedure setCHCCIE;
    procedure setCHCCIF;
    procedure setCHDDIE;
    procedure setCHDDIF;
    procedure setCHDHIE;
    procedure setCHDHIF;
    procedure setCHERIE;
    procedure setCHERIF;
    procedure setCHSDIE;
    procedure setCHSDIF;
    procedure setCHSHIE;
    procedure setCHSHIF;
    procedure setCHTAIE;
    procedure setCHTAIF;
    property CHBCIE : TBits_1 read getCHBCIE write setCHBCIE;
    property CHBCIF : TBits_1 read getCHBCIF write setCHBCIF;
    property CHCCIE : TBits_1 read getCHCCIE write setCHCCIE;
    property CHCCIF : TBits_1 read getCHCCIF write setCHCCIF;
    property CHDDIE : TBits_1 read getCHDDIE write setCHDDIE;
    property CHDDIF : TBits_1 read getCHDDIF write setCHDDIF;
    property CHDHIE : TBits_1 read getCHDHIE write setCHDHIE;
    property CHDHIF : TBits_1 read getCHDHIF write setCHDHIF;
    property CHERIE : TBits_1 read getCHERIE write setCHERIE;
    property CHERIF : TBits_1 read getCHERIF write setCHERIF;
    property CHSDIE : TBits_1 read getCHSDIE write setCHSDIE;
    property CHSDIF : TBits_1 read getCHSDIF write setCHSDIF;
    property CHSHIE : TBits_1 read getCHSHIE write setCHSHIE;
    property CHSHIF : TBits_1 read getCHSHIF write setCHSHIF;
    property CHTAIE : TBits_1 read getCHTAIE write setCHTAIE;
    property CHTAIF : TBits_1 read getCHTAIF write setCHTAIF;
    property w : TBits_32 read getw write setw;
  end;
type
  TDMAC0Registers = record
    DCH0CONbits : TDMAC0_DCH0CON;
    DCH0CON : longWord;
    DCH0CONCLR : longWord;
    DCH0CONSET : longWord;
    DCH0CONINV : longWord;
    DCH0ECONbits : TDMAC0_DCH0ECON;
    DCH0ECON : longWord;
    DCH0ECONCLR : longWord;
    DCH0ECONSET : longWord;
    DCH0ECONINV : longWord;
    DCH0INTbits : TDMAC0_DCH0INT;
    DCH0INT : longWord;
    DCH0INTCLR : longWord;
    DCH0INTSET : longWord;
    DCH0INTINV : longWord;
    DCH0SSA : longWord;
    DCH0SSACLR : longWord;
    DCH0SSASET : longWord;
    DCH0SSAINV : longWord;
    DCH0DSA : longWord;
    DCH0DSACLR : longWord;
    DCH0DSASET : longWord;
    DCH0DSAINV : longWord;
    DCH0SSIZ : longWord;
    DCH0SSIZCLR : longWord;
    DCH0SSIZSET : longWord;
    DCH0SSIZINV : longWord;
    DCH0DSIZ : longWord;
    DCH0DSIZCLR : longWord;
    DCH0DSIZSET : longWord;
    DCH0DSIZINV : longWord;
    DCH0SPTR : longWord;
    DCH0SPTRCLR : longWord;
    DCH0SPTRSET : longWord;
    DCH0SPTRINV : longWord;
    DCH0DPTR : longWord;
    DCH0DPTRCLR : longWord;
    DCH0DPTRSET : longWord;
    DCH0DPTRINV : longWord;
    DCH0CSIZ : longWord;
    DCH0CSIZCLR : longWord;
    DCH0CSIZSET : longWord;
    DCH0CSIZINV : longWord;
    DCH0CPTR : longWord;
    DCH0CPTRCLR : longWord;
    DCH0CPTRSET : longWord;
    DCH0CPTRINV : longWord;
    DCH0DAT : longWord;
    DCH0DATCLR : longWord;
    DCH0DATSET : longWord;
    DCH0DATINV : longWord;
  end;
  TDMAC1_DCH1CON = record
  private
    function  getCHAED : TBits_1; assembler; nostackframe; inline;
    function  getCHAEN : TBits_1; assembler; nostackframe; inline;
    function  getCHCHN : TBits_1; assembler; nostackframe; inline;
    function  getCHCHNS : TBits_1; assembler; nostackframe; inline;
    function  getCHEDET : TBits_1; assembler; nostackframe; inline;
    function  getCHEN : TBits_1; assembler; nostackframe; inline;
    function  getCHPRI : TBits_2; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCHAED(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHAEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCHN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCHNS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHEDET(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHPRI(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCHAED;
    procedure clearCHAEN;
    procedure clearCHCHN;
    procedure clearCHCHNS;
    procedure clearCHEDET;
    procedure clearCHEN;
    procedure setCHAED;
    procedure setCHAEN;
    procedure setCHCHN;
    procedure setCHCHNS;
    procedure setCHEDET;
    procedure setCHEN;
    property CHAED : TBits_1 read getCHAED write setCHAED;
    property CHAEN : TBits_1 read getCHAEN write setCHAEN;
    property CHCHN : TBits_1 read getCHCHN write setCHCHN;
    property CHCHNS : TBits_1 read getCHCHNS write setCHCHNS;
    property CHEDET : TBits_1 read getCHEDET write setCHEDET;
    property CHEN : TBits_1 read getCHEN write setCHEN;
    property CHPRI : TBits_2 read getCHPRI write setCHPRI;
    property w : TBits_32 read getw write setw;
  end;
  TDMAC1_DCH1ECON = record
  private
    function  getAIRQEN : TBits_1; assembler; nostackframe; inline;
    function  getCABORT : TBits_1; assembler; nostackframe; inline;
    function  getCFORCE : TBits_1; assembler; nostackframe; inline;
    function  getCHAIRQ : TBits_8; assembler; nostackframe; inline;
    function  getCHSIRQ : TBits_8; assembler; nostackframe; inline;
    function  getPATEN : TBits_1; assembler; nostackframe; inline;
    function  getSIRQEN : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setAIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCABORT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCFORCE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHAIRQ(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setCHSIRQ(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setPATEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearAIRQEN;
    procedure clearCABORT;
    procedure clearCFORCE;
    procedure clearPATEN;
    procedure clearSIRQEN;
    procedure setAIRQEN;
    procedure setCABORT;
    procedure setCFORCE;
    procedure setPATEN;
    procedure setSIRQEN;
    property AIRQEN : TBits_1 read getAIRQEN write setAIRQEN;
    property CABORT : TBits_1 read getCABORT write setCABORT;
    property CFORCE : TBits_1 read getCFORCE write setCFORCE;
    property CHAIRQ : TBits_8 read getCHAIRQ write setCHAIRQ;
    property CHSIRQ : TBits_8 read getCHSIRQ write setCHSIRQ;
    property PATEN : TBits_1 read getPATEN write setPATEN;
    property SIRQEN : TBits_1 read getSIRQEN write setSIRQEN;
    property w : TBits_32 read getw write setw;
  end;
  TDMAC1_DCH1INT = record
  private
    function  getCHBCIE : TBits_1; assembler; nostackframe; inline;
    function  getCHBCIF : TBits_1; assembler; nostackframe; inline;
    function  getCHCCIE : TBits_1; assembler; nostackframe; inline;
    function  getCHCCIF : TBits_1; assembler; nostackframe; inline;
    function  getCHDDIE : TBits_1; assembler; nostackframe; inline;
    function  getCHDDIF : TBits_1; assembler; nostackframe; inline;
    function  getCHDHIE : TBits_1; assembler; nostackframe; inline;
    function  getCHDHIF : TBits_1; assembler; nostackframe; inline;
    function  getCHERIE : TBits_1; assembler; nostackframe; inline;
    function  getCHERIF : TBits_1; assembler; nostackframe; inline;
    function  getCHSDIE : TBits_1; assembler; nostackframe; inline;
    function  getCHSDIF : TBits_1; assembler; nostackframe; inline;
    function  getCHSHIE : TBits_1; assembler; nostackframe; inline;
    function  getCHSHIF : TBits_1; assembler; nostackframe; inline;
    function  getCHTAIE : TBits_1; assembler; nostackframe; inline;
    function  getCHTAIF : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCHBCIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHBCIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCCIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCCIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDDIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDDIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDHIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDHIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHERIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHERIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSDIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSDIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSHIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSHIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHTAIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHTAIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCHBCIE;
    procedure clearCHBCIF;
    procedure clearCHCCIE;
    procedure clearCHCCIF;
    procedure clearCHDDIE;
    procedure clearCHDDIF;
    procedure clearCHDHIE;
    procedure clearCHDHIF;
    procedure clearCHERIE;
    procedure clearCHERIF;
    procedure clearCHSDIE;
    procedure clearCHSDIF;
    procedure clearCHSHIE;
    procedure clearCHSHIF;
    procedure clearCHTAIE;
    procedure clearCHTAIF;
    procedure setCHBCIE;
    procedure setCHBCIF;
    procedure setCHCCIE;
    procedure setCHCCIF;
    procedure setCHDDIE;
    procedure setCHDDIF;
    procedure setCHDHIE;
    procedure setCHDHIF;
    procedure setCHERIE;
    procedure setCHERIF;
    procedure setCHSDIE;
    procedure setCHSDIF;
    procedure setCHSHIE;
    procedure setCHSHIF;
    procedure setCHTAIE;
    procedure setCHTAIF;
    property CHBCIE : TBits_1 read getCHBCIE write setCHBCIE;
    property CHBCIF : TBits_1 read getCHBCIF write setCHBCIF;
    property CHCCIE : TBits_1 read getCHCCIE write setCHCCIE;
    property CHCCIF : TBits_1 read getCHCCIF write setCHCCIF;
    property CHDDIE : TBits_1 read getCHDDIE write setCHDDIE;
    property CHDDIF : TBits_1 read getCHDDIF write setCHDDIF;
    property CHDHIE : TBits_1 read getCHDHIE write setCHDHIE;
    property CHDHIF : TBits_1 read getCHDHIF write setCHDHIF;
    property CHERIE : TBits_1 read getCHERIE write setCHERIE;
    property CHERIF : TBits_1 read getCHERIF write setCHERIF;
    property CHSDIE : TBits_1 read getCHSDIE write setCHSDIE;
    property CHSDIF : TBits_1 read getCHSDIF write setCHSDIF;
    property CHSHIE : TBits_1 read getCHSHIE write setCHSHIE;
    property CHSHIF : TBits_1 read getCHSHIF write setCHSHIF;
    property CHTAIE : TBits_1 read getCHTAIE write setCHTAIE;
    property CHTAIF : TBits_1 read getCHTAIF write setCHTAIF;
    property w : TBits_32 read getw write setw;
  end;
type
  TDMAC1Registers = record
    DCH1CONbits : TDMAC1_DCH1CON;
    DCH1CON : longWord;
    DCH1CONCLR : longWord;
    DCH1CONSET : longWord;
    DCH1CONINV : longWord;
    DCH1ECONbits : TDMAC1_DCH1ECON;
    DCH1ECON : longWord;
    DCH1ECONCLR : longWord;
    DCH1ECONSET : longWord;
    DCH1ECONINV : longWord;
    DCH1INTbits : TDMAC1_DCH1INT;
    DCH1INT : longWord;
    DCH1INTCLR : longWord;
    DCH1INTSET : longWord;
    DCH1INTINV : longWord;
    DCH1SSA : longWord;
    DCH1SSACLR : longWord;
    DCH1SSASET : longWord;
    DCH1SSAINV : longWord;
    DCH1DSA : longWord;
    DCH1DSACLR : longWord;
    DCH1DSASET : longWord;
    DCH1DSAINV : longWord;
    DCH1SSIZ : longWord;
    DCH1SSIZCLR : longWord;
    DCH1SSIZSET : longWord;
    DCH1SSIZINV : longWord;
    DCH1DSIZ : longWord;
    DCH1DSIZCLR : longWord;
    DCH1DSIZSET : longWord;
    DCH1DSIZINV : longWord;
    DCH1SPTR : longWord;
    DCH1SPTRCLR : longWord;
    DCH1SPTRSET : longWord;
    DCH1SPTRINV : longWord;
    DCH1DPTR : longWord;
    DCH1DPTRCLR : longWord;
    DCH1DPTRSET : longWord;
    DCH1DPTRINV : longWord;
    DCH1CSIZ : longWord;
    DCH1CSIZCLR : longWord;
    DCH1CSIZSET : longWord;
    DCH1CSIZINV : longWord;
    DCH1CPTR : longWord;
    DCH1CPTRCLR : longWord;
    DCH1CPTRSET : longWord;
    DCH1CPTRINV : longWord;
    DCH1DAT : longWord;
    DCH1DATCLR : longWord;
    DCH1DATSET : longWord;
    DCH1DATINV : longWord;
  end;
  TDMAC2_DCH2CON = record
  private
    function  getCHAED : TBits_1; assembler; nostackframe; inline;
    function  getCHAEN : TBits_1; assembler; nostackframe; inline;
    function  getCHCHN : TBits_1; assembler; nostackframe; inline;
    function  getCHCHNS : TBits_1; assembler; nostackframe; inline;
    function  getCHEDET : TBits_1; assembler; nostackframe; inline;
    function  getCHEN : TBits_1; assembler; nostackframe; inline;
    function  getCHPRI : TBits_2; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCHAED(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHAEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCHN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCHNS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHEDET(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHPRI(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCHAED;
    procedure clearCHAEN;
    procedure clearCHCHN;
    procedure clearCHCHNS;
    procedure clearCHEDET;
    procedure clearCHEN;
    procedure setCHAED;
    procedure setCHAEN;
    procedure setCHCHN;
    procedure setCHCHNS;
    procedure setCHEDET;
    procedure setCHEN;
    property CHAED : TBits_1 read getCHAED write setCHAED;
    property CHAEN : TBits_1 read getCHAEN write setCHAEN;
    property CHCHN : TBits_1 read getCHCHN write setCHCHN;
    property CHCHNS : TBits_1 read getCHCHNS write setCHCHNS;
    property CHEDET : TBits_1 read getCHEDET write setCHEDET;
    property CHEN : TBits_1 read getCHEN write setCHEN;
    property CHPRI : TBits_2 read getCHPRI write setCHPRI;
    property w : TBits_32 read getw write setw;
  end;
  TDMAC2_DCH2ECON = record
  private
    function  getAIRQEN : TBits_1; assembler; nostackframe; inline;
    function  getCABORT : TBits_1; assembler; nostackframe; inline;
    function  getCFORCE : TBits_1; assembler; nostackframe; inline;
    function  getCHAIRQ : TBits_8; assembler; nostackframe; inline;
    function  getCHSIRQ : TBits_8; assembler; nostackframe; inline;
    function  getPATEN : TBits_1; assembler; nostackframe; inline;
    function  getSIRQEN : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setAIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCABORT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCFORCE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHAIRQ(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setCHSIRQ(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setPATEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearAIRQEN;
    procedure clearCABORT;
    procedure clearCFORCE;
    procedure clearPATEN;
    procedure clearSIRQEN;
    procedure setAIRQEN;
    procedure setCABORT;
    procedure setCFORCE;
    procedure setPATEN;
    procedure setSIRQEN;
    property AIRQEN : TBits_1 read getAIRQEN write setAIRQEN;
    property CABORT : TBits_1 read getCABORT write setCABORT;
    property CFORCE : TBits_1 read getCFORCE write setCFORCE;
    property CHAIRQ : TBits_8 read getCHAIRQ write setCHAIRQ;
    property CHSIRQ : TBits_8 read getCHSIRQ write setCHSIRQ;
    property PATEN : TBits_1 read getPATEN write setPATEN;
    property SIRQEN : TBits_1 read getSIRQEN write setSIRQEN;
    property w : TBits_32 read getw write setw;
  end;
  TDMAC2_DCH2INT = record
  private
    function  getCHBCIE : TBits_1; assembler; nostackframe; inline;
    function  getCHBCIF : TBits_1; assembler; nostackframe; inline;
    function  getCHCCIE : TBits_1; assembler; nostackframe; inline;
    function  getCHCCIF : TBits_1; assembler; nostackframe; inline;
    function  getCHDDIE : TBits_1; assembler; nostackframe; inline;
    function  getCHDDIF : TBits_1; assembler; nostackframe; inline;
    function  getCHDHIE : TBits_1; assembler; nostackframe; inline;
    function  getCHDHIF : TBits_1; assembler; nostackframe; inline;
    function  getCHERIE : TBits_1; assembler; nostackframe; inline;
    function  getCHERIF : TBits_1; assembler; nostackframe; inline;
    function  getCHSDIE : TBits_1; assembler; nostackframe; inline;
    function  getCHSDIF : TBits_1; assembler; nostackframe; inline;
    function  getCHSHIE : TBits_1; assembler; nostackframe; inline;
    function  getCHSHIF : TBits_1; assembler; nostackframe; inline;
    function  getCHTAIE : TBits_1; assembler; nostackframe; inline;
    function  getCHTAIF : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCHBCIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHBCIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCCIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCCIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDDIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDDIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDHIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDHIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHERIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHERIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSDIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSDIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSHIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSHIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHTAIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHTAIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCHBCIE;
    procedure clearCHBCIF;
    procedure clearCHCCIE;
    procedure clearCHCCIF;
    procedure clearCHDDIE;
    procedure clearCHDDIF;
    procedure clearCHDHIE;
    procedure clearCHDHIF;
    procedure clearCHERIE;
    procedure clearCHERIF;
    procedure clearCHSDIE;
    procedure clearCHSDIF;
    procedure clearCHSHIE;
    procedure clearCHSHIF;
    procedure clearCHTAIE;
    procedure clearCHTAIF;
    procedure setCHBCIE;
    procedure setCHBCIF;
    procedure setCHCCIE;
    procedure setCHCCIF;
    procedure setCHDDIE;
    procedure setCHDDIF;
    procedure setCHDHIE;
    procedure setCHDHIF;
    procedure setCHERIE;
    procedure setCHERIF;
    procedure setCHSDIE;
    procedure setCHSDIF;
    procedure setCHSHIE;
    procedure setCHSHIF;
    procedure setCHTAIE;
    procedure setCHTAIF;
    property CHBCIE : TBits_1 read getCHBCIE write setCHBCIE;
    property CHBCIF : TBits_1 read getCHBCIF write setCHBCIF;
    property CHCCIE : TBits_1 read getCHCCIE write setCHCCIE;
    property CHCCIF : TBits_1 read getCHCCIF write setCHCCIF;
    property CHDDIE : TBits_1 read getCHDDIE write setCHDDIE;
    property CHDDIF : TBits_1 read getCHDDIF write setCHDDIF;
    property CHDHIE : TBits_1 read getCHDHIE write setCHDHIE;
    property CHDHIF : TBits_1 read getCHDHIF write setCHDHIF;
    property CHERIE : TBits_1 read getCHERIE write setCHERIE;
    property CHERIF : TBits_1 read getCHERIF write setCHERIF;
    property CHSDIE : TBits_1 read getCHSDIE write setCHSDIE;
    property CHSDIF : TBits_1 read getCHSDIF write setCHSDIF;
    property CHSHIE : TBits_1 read getCHSHIE write setCHSHIE;
    property CHSHIF : TBits_1 read getCHSHIF write setCHSHIF;
    property CHTAIE : TBits_1 read getCHTAIE write setCHTAIE;
    property CHTAIF : TBits_1 read getCHTAIF write setCHTAIF;
    property w : TBits_32 read getw write setw;
  end;
type
  TDMAC2Registers = record
    DCH2CONbits : TDMAC2_DCH2CON;
    DCH2CON : longWord;
    DCH2CONCLR : longWord;
    DCH2CONSET : longWord;
    DCH2CONINV : longWord;
    DCH2ECONbits : TDMAC2_DCH2ECON;
    DCH2ECON : longWord;
    DCH2ECONCLR : longWord;
    DCH2ECONSET : longWord;
    DCH2ECONINV : longWord;
    DCH2INTbits : TDMAC2_DCH2INT;
    DCH2INT : longWord;
    DCH2INTCLR : longWord;
    DCH2INTSET : longWord;
    DCH2INTINV : longWord;
    DCH2SSA : longWord;
    DCH2SSACLR : longWord;
    DCH2SSASET : longWord;
    DCH2SSAINV : longWord;
    DCH2DSA : longWord;
    DCH2DSACLR : longWord;
    DCH2DSASET : longWord;
    DCH2DSAINV : longWord;
    DCH2SSIZ : longWord;
    DCH2SSIZCLR : longWord;
    DCH2SSIZSET : longWord;
    DCH2SSIZINV : longWord;
    DCH2DSIZ : longWord;
    DCH2DSIZCLR : longWord;
    DCH2DSIZSET : longWord;
    DCH2DSIZINV : longWord;
    DCH2SPTR : longWord;
    DCH2SPTRCLR : longWord;
    DCH2SPTRSET : longWord;
    DCH2SPTRINV : longWord;
    DCH2DPTR : longWord;
    DCH2DPTRCLR : longWord;
    DCH2DPTRSET : longWord;
    DCH2DPTRINV : longWord;
    DCH2CSIZ : longWord;
    DCH2CSIZCLR : longWord;
    DCH2CSIZSET : longWord;
    DCH2CSIZINV : longWord;
    DCH2CPTR : longWord;
    DCH2CPTRCLR : longWord;
    DCH2CPTRSET : longWord;
    DCH2CPTRINV : longWord;
    DCH2DAT : longWord;
    DCH2DATCLR : longWord;
    DCH2DATSET : longWord;
    DCH2DATINV : longWord;
  end;
  TDMAC3_DCH3CON = record
  private
    function  getCHAED : TBits_1; assembler; nostackframe; inline;
    function  getCHAEN : TBits_1; assembler; nostackframe; inline;
    function  getCHCHN : TBits_1; assembler; nostackframe; inline;
    function  getCHCHNS : TBits_1; assembler; nostackframe; inline;
    function  getCHEDET : TBits_1; assembler; nostackframe; inline;
    function  getCHEN : TBits_1; assembler; nostackframe; inline;
    function  getCHPRI : TBits_2; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCHAED(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHAEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCHN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCHNS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHEDET(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHPRI(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCHAED;
    procedure clearCHAEN;
    procedure clearCHCHN;
    procedure clearCHCHNS;
    procedure clearCHEDET;
    procedure clearCHEN;
    procedure setCHAED;
    procedure setCHAEN;
    procedure setCHCHN;
    procedure setCHCHNS;
    procedure setCHEDET;
    procedure setCHEN;
    property CHAED : TBits_1 read getCHAED write setCHAED;
    property CHAEN : TBits_1 read getCHAEN write setCHAEN;
    property CHCHN : TBits_1 read getCHCHN write setCHCHN;
    property CHCHNS : TBits_1 read getCHCHNS write setCHCHNS;
    property CHEDET : TBits_1 read getCHEDET write setCHEDET;
    property CHEN : TBits_1 read getCHEN write setCHEN;
    property CHPRI : TBits_2 read getCHPRI write setCHPRI;
    property w : TBits_32 read getw write setw;
  end;
  TDMAC3_DCH3ECON = record
  private
    function  getAIRQEN : TBits_1; assembler; nostackframe; inline;
    function  getCABORT : TBits_1; assembler; nostackframe; inline;
    function  getCFORCE : TBits_1; assembler; nostackframe; inline;
    function  getCHAIRQ : TBits_8; assembler; nostackframe; inline;
    function  getCHSIRQ : TBits_8; assembler; nostackframe; inline;
    function  getPATEN : TBits_1; assembler; nostackframe; inline;
    function  getSIRQEN : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setAIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCABORT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCFORCE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHAIRQ(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setCHSIRQ(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setPATEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearAIRQEN;
    procedure clearCABORT;
    procedure clearCFORCE;
    procedure clearPATEN;
    procedure clearSIRQEN;
    procedure setAIRQEN;
    procedure setCABORT;
    procedure setCFORCE;
    procedure setPATEN;
    procedure setSIRQEN;
    property AIRQEN : TBits_1 read getAIRQEN write setAIRQEN;
    property CABORT : TBits_1 read getCABORT write setCABORT;
    property CFORCE : TBits_1 read getCFORCE write setCFORCE;
    property CHAIRQ : TBits_8 read getCHAIRQ write setCHAIRQ;
    property CHSIRQ : TBits_8 read getCHSIRQ write setCHSIRQ;
    property PATEN : TBits_1 read getPATEN write setPATEN;
    property SIRQEN : TBits_1 read getSIRQEN write setSIRQEN;
    property w : TBits_32 read getw write setw;
  end;
  TDMAC3_DCH3INT = record
  private
    function  getCHBCIE : TBits_1; assembler; nostackframe; inline;
    function  getCHBCIF : TBits_1; assembler; nostackframe; inline;
    function  getCHCCIE : TBits_1; assembler; nostackframe; inline;
    function  getCHCCIF : TBits_1; assembler; nostackframe; inline;
    function  getCHDDIE : TBits_1; assembler; nostackframe; inline;
    function  getCHDDIF : TBits_1; assembler; nostackframe; inline;
    function  getCHDHIE : TBits_1; assembler; nostackframe; inline;
    function  getCHDHIF : TBits_1; assembler; nostackframe; inline;
    function  getCHERIE : TBits_1; assembler; nostackframe; inline;
    function  getCHERIF : TBits_1; assembler; nostackframe; inline;
    function  getCHSDIE : TBits_1; assembler; nostackframe; inline;
    function  getCHSDIF : TBits_1; assembler; nostackframe; inline;
    function  getCHSHIE : TBits_1; assembler; nostackframe; inline;
    function  getCHSHIF : TBits_1; assembler; nostackframe; inline;
    function  getCHTAIE : TBits_1; assembler; nostackframe; inline;
    function  getCHTAIF : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCHBCIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHBCIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCCIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHCCIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDDIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDDIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDHIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHDHIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHERIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHERIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSDIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSDIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSHIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHSHIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHTAIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCHTAIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCHBCIE;
    procedure clearCHBCIF;
    procedure clearCHCCIE;
    procedure clearCHCCIF;
    procedure clearCHDDIE;
    procedure clearCHDDIF;
    procedure clearCHDHIE;
    procedure clearCHDHIF;
    procedure clearCHERIE;
    procedure clearCHERIF;
    procedure clearCHSDIE;
    procedure clearCHSDIF;
    procedure clearCHSHIE;
    procedure clearCHSHIF;
    procedure clearCHTAIE;
    procedure clearCHTAIF;
    procedure setCHBCIE;
    procedure setCHBCIF;
    procedure setCHCCIE;
    procedure setCHCCIF;
    procedure setCHDDIE;
    procedure setCHDDIF;
    procedure setCHDHIE;
    procedure setCHDHIF;
    procedure setCHERIE;
    procedure setCHERIF;
    procedure setCHSDIE;
    procedure setCHSDIF;
    procedure setCHSHIE;
    procedure setCHSHIF;
    procedure setCHTAIE;
    procedure setCHTAIF;
    property CHBCIE : TBits_1 read getCHBCIE write setCHBCIE;
    property CHBCIF : TBits_1 read getCHBCIF write setCHBCIF;
    property CHCCIE : TBits_1 read getCHCCIE write setCHCCIE;
    property CHCCIF : TBits_1 read getCHCCIF write setCHCCIF;
    property CHDDIE : TBits_1 read getCHDDIE write setCHDDIE;
    property CHDDIF : TBits_1 read getCHDDIF write setCHDDIF;
    property CHDHIE : TBits_1 read getCHDHIE write setCHDHIE;
    property CHDHIF : TBits_1 read getCHDHIF write setCHDHIF;
    property CHERIE : TBits_1 read getCHERIE write setCHERIE;
    property CHERIF : TBits_1 read getCHERIF write setCHERIF;
    property CHSDIE : TBits_1 read getCHSDIE write setCHSDIE;
    property CHSDIF : TBits_1 read getCHSDIF write setCHSDIF;
    property CHSHIE : TBits_1 read getCHSHIE write setCHSHIE;
    property CHSHIF : TBits_1 read getCHSHIF write setCHSHIF;
    property CHTAIE : TBits_1 read getCHTAIE write setCHTAIE;
    property CHTAIF : TBits_1 read getCHTAIF write setCHTAIF;
    property w : TBits_32 read getw write setw;
  end;
type
  TDMAC3Registers = record
    DCH3CONbits : TDMAC3_DCH3CON;
    DCH3CON : longWord;
    DCH3CONCLR : longWord;
    DCH3CONSET : longWord;
    DCH3CONINV : longWord;
    DCH3ECONbits : TDMAC3_DCH3ECON;
    DCH3ECON : longWord;
    DCH3ECONCLR : longWord;
    DCH3ECONSET : longWord;
    DCH3ECONINV : longWord;
    DCH3INTbits : TDMAC3_DCH3INT;
    DCH3INT : longWord;
    DCH3INTCLR : longWord;
    DCH3INTSET : longWord;
    DCH3INTINV : longWord;
    DCH3SSA : longWord;
    DCH3SSACLR : longWord;
    DCH3SSASET : longWord;
    DCH3SSAINV : longWord;
    DCH3DSA : longWord;
    DCH3DSACLR : longWord;
    DCH3DSASET : longWord;
    DCH3DSAINV : longWord;
    DCH3SSIZ : longWord;
    DCH3SSIZCLR : longWord;
    DCH3SSIZSET : longWord;
    DCH3SSIZINV : longWord;
    DCH3DSIZ : longWord;
    DCH3DSIZCLR : longWord;
    DCH3DSIZSET : longWord;
    DCH3DSIZINV : longWord;
    DCH3SPTR : longWord;
    DCH3SPTRCLR : longWord;
    DCH3SPTRSET : longWord;
    DCH3SPTRINV : longWord;
    DCH3DPTR : longWord;
    DCH3DPTRCLR : longWord;
    DCH3DPTRSET : longWord;
    DCH3DPTRINV : longWord;
    DCH3CSIZ : longWord;
    DCH3CSIZCLR : longWord;
    DCH3CSIZSET : longWord;
    DCH3CSIZINV : longWord;
    DCH3CPTR : longWord;
    DCH3CPTRCLR : longWord;
    DCH3CPTRSET : longWord;
    DCH3CPTRINV : longWord;
    DCH3DAT : longWord;
    DCH3DATCLR : longWord;
    DCH3DATSET : longWord;
    DCH3DATINV : longWord;
  end;
  TPCACHE_CHECON = record
  private
    function  getCHECOH : TBits_1; assembler; nostackframe; inline;
    function  getDCSZ : TBits_2; assembler; nostackframe; inline;
    function  getPFMWS : TBits_3; assembler; nostackframe; inline;
    function  getPREFEN : TBits_2; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCHECOH(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDCSZ(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setPFMWS(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setPREFEN(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCHECOH;
    procedure setCHECOH;
    property CHECOH : TBits_1 read getCHECOH write setCHECOH;
    property DCSZ : TBits_2 read getDCSZ write setDCSZ;
    property PFMWS : TBits_3 read getPFMWS write setPFMWS;
    property PREFEN : TBits_2 read getPREFEN write setPREFEN;
    property w : TBits_32 read getw write setw;
  end;
  TPCACHE_CHETAG = record
  private
    function  getLLOCK : TBits_1; assembler; nostackframe; inline;
    function  getLTAG : TBits_20; assembler; nostackframe; inline;
    function  getLTAGBOOT : TBits_1; assembler; nostackframe; inline;
    function  getLTYPE : TBits_1; assembler; nostackframe; inline;
    function  getLVALID : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setLLOCK(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLTAG(thebits : TBits_20); assembler; nostackframe; inline;
    procedure setLTAGBOOT(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLTYPE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLVALID(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearLLOCK;
    procedure clearLTAGBOOT;
    procedure clearLTYPE;
    procedure clearLVALID;
    procedure setLLOCK;
    procedure setLTAGBOOT;
    procedure setLTYPE;
    procedure setLVALID;
    property LLOCK : TBits_1 read getLLOCK write setLLOCK;
    property LTAG : TBits_20 read getLTAG write setLTAG;
    property LTAGBOOT : TBits_1 read getLTAGBOOT write setLTAGBOOT;
    property LTYPE : TBits_1 read getLTYPE write setLTYPE;
    property LVALID : TBits_1 read getLVALID write setLVALID;
    property w : TBits_32 read getw write setw;
  end;
type
  TPCACHERegisters = record
    CHECONbits : TPCACHE_CHECON;
    CHECON : longWord;
    CHECONCLR : longWord;
    CHECONSET : longWord;
    CHECONINV : longWord;
    CHEACC : longWord;
    CHEACCCLR : longWord;
    CHEACCSET : longWord;
    CHEACCINV : longWord;
    CHETAGbits : TPCACHE_CHETAG;
    CHETAG : longWord;
    CHETAGCLR : longWord;
    CHETAGSET : longWord;
    CHETAGINV : longWord;
    CHEMSK : longWord;
    CHEMSKCLR : longWord;
    CHEMSKSET : longWord;
    CHEMSKINV : longWord;
    CHEW0 : longWord;
    CHEW1 : longWord;
    CHEW2 : longWord;
    CHEW3 : longWord;
    CHELRU : longWord;
    CHEHIT : longWord;
    CHEMIS : longWord;
    CHEPFABT : longWord;
  end;
  TUSB_U1IR = record
  private
    function  getATTACHIF : TBits_1; assembler; nostackframe; inline;
    function  getDETACHIF : TBits_1; assembler; nostackframe; inline;
    function  getIDLEIF : TBits_1; assembler; nostackframe; inline;
    function  getRESUMEIF : TBits_1; assembler; nostackframe; inline;
    function  getSOFIF : TBits_1; assembler; nostackframe; inline;
    function  getSTALLIF : TBits_1; assembler; nostackframe; inline;
    function  getTRNIF : TBits_1; assembler; nostackframe; inline;
    function  getUERRIF : TBits_1; assembler; nostackframe; inline;
    function  getURSTIF : TBits_1; assembler; nostackframe; inline;
    function  getURSTIF_DETACHIF : TBits_1; assembler; nostackframe; inline;
    procedure setATTACHIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDETACHIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIDLEIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRESUMEIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSOFIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSTALLIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRNIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUERRIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setURSTIF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setURSTIF_DETACHIF(thebits : TBits_1); assembler; nostackframe; inline;
  public
    procedure clearATTACHIF;
    procedure clearDETACHIF;
    procedure clearIDLEIF;
    procedure clearRESUMEIF;
    procedure clearSOFIF;
    procedure clearSTALLIF;
    procedure clearTRNIF;
    procedure clearUERRIF;
    procedure clearURSTIF;
    procedure clearURSTIF_DETACHIF;
    procedure setATTACHIF;
    procedure setDETACHIF;
    procedure setIDLEIF;
    procedure setRESUMEIF;
    procedure setSOFIF;
    procedure setSTALLIF;
    procedure setTRNIF;
    procedure setUERRIF;
    procedure setURSTIF;
    procedure setURSTIF_DETACHIF;
    property ATTACHIF : TBits_1 read getATTACHIF write setATTACHIF;
    property DETACHIF : TBits_1 read getDETACHIF write setDETACHIF;
    property IDLEIF : TBits_1 read getIDLEIF write setIDLEIF;
    property RESUMEIF : TBits_1 read getRESUMEIF write setRESUMEIF;
    property SOFIF : TBits_1 read getSOFIF write setSOFIF;
    property STALLIF : TBits_1 read getSTALLIF write setSTALLIF;
    property TRNIF : TBits_1 read getTRNIF write setTRNIF;
    property UERRIF : TBits_1 read getUERRIF write setUERRIF;
    property URSTIF : TBits_1 read getURSTIF write setURSTIF;
    property URSTIF_DETACHIF : TBits_1 read getURSTIF_DETACHIF write setURSTIF_DETACHIF;
  end;
  TUSB_U1IE = record
  private
    function  getATTACHIE : TBits_1; assembler; nostackframe; inline;
    function  getDETACHIE : TBits_1; assembler; nostackframe; inline;
    function  getIDLEIE : TBits_1; assembler; nostackframe; inline;
    function  getRESUMEIE : TBits_1; assembler; nostackframe; inline;
    function  getSOFIE : TBits_1; assembler; nostackframe; inline;
    function  getSTALLIE : TBits_1; assembler; nostackframe; inline;
    function  getTRNIE : TBits_1; assembler; nostackframe; inline;
    function  getUERRIE : TBits_1; assembler; nostackframe; inline;
    function  getURSTIE : TBits_1; assembler; nostackframe; inline;
    function  getURSTIE_DETACHIE : TBits_1; assembler; nostackframe; inline;
    procedure setATTACHIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDETACHIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIDLEIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRESUMEIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSOFIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSTALLIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRNIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUERRIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setURSTIE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setURSTIE_DETACHIE(thebits : TBits_1); assembler; nostackframe; inline;
  public
    procedure clearATTACHIE;
    procedure clearDETACHIE;
    procedure clearIDLEIE;
    procedure clearRESUMEIE;
    procedure clearSOFIE;
    procedure clearSTALLIE;
    procedure clearTRNIE;
    procedure clearUERRIE;
    procedure clearURSTIE;
    procedure clearURSTIE_DETACHIE;
    procedure setATTACHIE;
    procedure setDETACHIE;
    procedure setIDLEIE;
    procedure setRESUMEIE;
    procedure setSOFIE;
    procedure setSTALLIE;
    procedure setTRNIE;
    procedure setUERRIE;
    procedure setURSTIE;
    procedure setURSTIE_DETACHIE;
    property ATTACHIE : TBits_1 read getATTACHIE write setATTACHIE;
    property DETACHIE : TBits_1 read getDETACHIE write setDETACHIE;
    property IDLEIE : TBits_1 read getIDLEIE write setIDLEIE;
    property RESUMEIE : TBits_1 read getRESUMEIE write setRESUMEIE;
    property SOFIE : TBits_1 read getSOFIE write setSOFIE;
    property STALLIE : TBits_1 read getSTALLIE write setSTALLIE;
    property TRNIE : TBits_1 read getTRNIE write setTRNIE;
    property UERRIE : TBits_1 read getUERRIE write setUERRIE;
    property URSTIE : TBits_1 read getURSTIE write setURSTIE;
    property URSTIE_DETACHIE : TBits_1 read getURSTIE_DETACHIE write setURSTIE_DETACHIE;
  end;
  TUSB_U1EIR = record
  private
    function  getBMXEF : TBits_1; assembler; nostackframe; inline;
    function  getBTOEF : TBits_1; assembler; nostackframe; inline;
    function  getBTSEF : TBits_1; assembler; nostackframe; inline;
    function  getCRC16EF : TBits_1; assembler; nostackframe; inline;
    function  getCRC5EF : TBits_1; assembler; nostackframe; inline;
    function  getCRC5EF_EOFEF : TBits_1; assembler; nostackframe; inline;
    function  getDFN8EF : TBits_1; assembler; nostackframe; inline;
    function  getDMAEF : TBits_1; assembler; nostackframe; inline;
    function  getEOFEF : TBits_1; assembler; nostackframe; inline;
    function  getPIDEF : TBits_1; assembler; nostackframe; inline;
    procedure setBMXEF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBTOEF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBTSEF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCRC16EF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCRC5EF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCRC5EF_EOFEF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDFN8EF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDMAEF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setEOFEF(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPIDEF(thebits : TBits_1); assembler; nostackframe; inline;
  public
    procedure clearBMXEF;
    procedure clearBTOEF;
    procedure clearBTSEF;
    procedure clearCRC16EF;
    procedure clearCRC5EF;
    procedure clearCRC5EF_EOFEF;
    procedure clearDFN8EF;
    procedure clearDMAEF;
    procedure clearEOFEF;
    procedure clearPIDEF;
    procedure setBMXEF;
    procedure setBTOEF;
    procedure setBTSEF;
    procedure setCRC16EF;
    procedure setCRC5EF;
    procedure setCRC5EF_EOFEF;
    procedure setDFN8EF;
    procedure setDMAEF;
    procedure setEOFEF;
    procedure setPIDEF;
    property BMXEF : TBits_1 read getBMXEF write setBMXEF;
    property BTOEF : TBits_1 read getBTOEF write setBTOEF;
    property BTSEF : TBits_1 read getBTSEF write setBTSEF;
    property CRC16EF : TBits_1 read getCRC16EF write setCRC16EF;
    property CRC5EF : TBits_1 read getCRC5EF write setCRC5EF;
    property CRC5EF_EOFEF : TBits_1 read getCRC5EF_EOFEF write setCRC5EF_EOFEF;
    property DFN8EF : TBits_1 read getDFN8EF write setDFN8EF;
    property DMAEF : TBits_1 read getDMAEF write setDMAEF;
    property EOFEF : TBits_1 read getEOFEF write setEOFEF;
    property PIDEF : TBits_1 read getPIDEF write setPIDEF;
  end;
  TUSB_U1EIE = record
  private
    function  getBMXEE : TBits_1; assembler; nostackframe; inline;
    function  getBTOEE : TBits_1; assembler; nostackframe; inline;
    function  getBTSEE : TBits_1; assembler; nostackframe; inline;
    function  getCRC16EE : TBits_1; assembler; nostackframe; inline;
    function  getCRC5EE : TBits_1; assembler; nostackframe; inline;
    function  getCRC5EE_EOFEE : TBits_1; assembler; nostackframe; inline;
    function  getDFN8EE : TBits_1; assembler; nostackframe; inline;
    function  getDMAEE : TBits_1; assembler; nostackframe; inline;
    function  getEOFEE : TBits_1; assembler; nostackframe; inline;
    function  getPIDEE : TBits_1; assembler; nostackframe; inline;
    procedure setBMXEE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBTOEE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setBTSEE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCRC16EE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCRC5EE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCRC5EE_EOFEE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDFN8EE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDMAEE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setEOFEE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPIDEE(thebits : TBits_1); assembler; nostackframe; inline;
  public
    procedure clearBMXEE;
    procedure clearBTOEE;
    procedure clearBTSEE;
    procedure clearCRC16EE;
    procedure clearCRC5EE;
    procedure clearCRC5EE_EOFEE;
    procedure clearDFN8EE;
    procedure clearDMAEE;
    procedure clearEOFEE;
    procedure clearPIDEE;
    procedure setBMXEE;
    procedure setBTOEE;
    procedure setBTSEE;
    procedure setCRC16EE;
    procedure setCRC5EE;
    procedure setCRC5EE_EOFEE;
    procedure setDFN8EE;
    procedure setDMAEE;
    procedure setEOFEE;
    procedure setPIDEE;
    property BMXEE : TBits_1 read getBMXEE write setBMXEE;
    property BTOEE : TBits_1 read getBTOEE write setBTOEE;
    property BTSEE : TBits_1 read getBTSEE write setBTSEE;
    property CRC16EE : TBits_1 read getCRC16EE write setCRC16EE;
    property CRC5EE : TBits_1 read getCRC5EE write setCRC5EE;
    property CRC5EE_EOFEE : TBits_1 read getCRC5EE_EOFEE write setCRC5EE_EOFEE;
    property DFN8EE : TBits_1 read getDFN8EE write setDFN8EE;
    property DMAEE : TBits_1 read getDMAEE write setDMAEE;
    property EOFEE : TBits_1 read getEOFEE write setEOFEE;
    property PIDEE : TBits_1 read getPIDEE write setPIDEE;
  end;
  TUSB_U1STAT = record
  private
    function  getDIR : TBits_1; assembler; nostackframe; inline;
    function  getENDPT : TBits_4; assembler; nostackframe; inline;
    function  getENDPT0 : TBits_1; assembler; nostackframe; inline;
    function  getENDPT1 : TBits_1; assembler; nostackframe; inline;
    function  getENDPT2 : TBits_1; assembler; nostackframe; inline;
    function  getENDPT3 : TBits_1; assembler; nostackframe; inline;
    function  getPPBI : TBits_1; assembler; nostackframe; inline;
    procedure setDIR(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setENDPT(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setENDPT0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setENDPT1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setENDPT2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setENDPT3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPPBI(thebits : TBits_1); assembler; nostackframe; inline;
  public
    procedure clearDIR;
    procedure clearENDPT0;
    procedure clearENDPT1;
    procedure clearENDPT2;
    procedure clearENDPT3;
    procedure clearPPBI;
    procedure setDIR;
    procedure setENDPT0;
    procedure setENDPT1;
    procedure setENDPT2;
    procedure setENDPT3;
    procedure setPPBI;
    property DIR : TBits_1 read getDIR write setDIR;
    property ENDPT : TBits_4 read getENDPT write setENDPT;
    property ENDPT0 : TBits_1 read getENDPT0 write setENDPT0;
    property ENDPT1 : TBits_1 read getENDPT1 write setENDPT1;
    property ENDPT2 : TBits_1 read getENDPT2 write setENDPT2;
    property ENDPT3 : TBits_1 read getENDPT3 write setENDPT3;
    property PPBI : TBits_1 read getPPBI write setPPBI;
  end;
  TUSB_U1CON = record
  private
    function  getHOSTEN : TBits_1; assembler; nostackframe; inline;
    function  getJSTATE : TBits_1; assembler; nostackframe; inline;
    function  getPKTDIS : TBits_1; assembler; nostackframe; inline;
    function  getPKTDIS_TOKBUSY : TBits_1; assembler; nostackframe; inline;
    function  getPPBRST : TBits_1; assembler; nostackframe; inline;
    function  getRESUME : TBits_1; assembler; nostackframe; inline;
    function  getSE0 : TBits_1; assembler; nostackframe; inline;
    function  getSOFEN : TBits_1; assembler; nostackframe; inline;
    function  getTOKBUSY : TBits_1; assembler; nostackframe; inline;
    function  getUSBEN : TBits_1; assembler; nostackframe; inline;
    function  getUSBEN_SOFEN : TBits_1; assembler; nostackframe; inline;
    function  getUSBRST : TBits_1; assembler; nostackframe; inline;
    procedure setHOSTEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setJSTATE(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPKTDIS(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPKTDIS_TOKBUSY(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPPBRST(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRESUME(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSE0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSOFEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTOKBUSY(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUSBEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUSBEN_SOFEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUSBRST(thebits : TBits_1); assembler; nostackframe; inline;
  public
    procedure clearHOSTEN;
    procedure clearJSTATE;
    procedure clearPKTDIS;
    procedure clearPKTDIS_TOKBUSY;
    procedure clearPPBRST;
    procedure clearRESUME;
    procedure clearSE0;
    procedure clearSOFEN;
    procedure clearTOKBUSY;
    procedure clearUSBEN;
    procedure clearUSBEN_SOFEN;
    procedure clearUSBRST;
    procedure setHOSTEN;
    procedure setJSTATE;
    procedure setPKTDIS;
    procedure setPKTDIS_TOKBUSY;
    procedure setPPBRST;
    procedure setRESUME;
    procedure setSE0;
    procedure setSOFEN;
    procedure setTOKBUSY;
    procedure setUSBEN;
    procedure setUSBEN_SOFEN;
    procedure setUSBRST;
    property HOSTEN : TBits_1 read getHOSTEN write setHOSTEN;
    property JSTATE : TBits_1 read getJSTATE write setJSTATE;
    property PKTDIS : TBits_1 read getPKTDIS write setPKTDIS;
    property PKTDIS_TOKBUSY : TBits_1 read getPKTDIS_TOKBUSY write setPKTDIS_TOKBUSY;
    property PPBRST : TBits_1 read getPPBRST write setPPBRST;
    property RESUME : TBits_1 read getRESUME write setRESUME;
    property SE0 : TBits_1 read getSE0 write setSE0;
    property SOFEN : TBits_1 read getSOFEN write setSOFEN;
    property TOKBUSY : TBits_1 read getTOKBUSY write setTOKBUSY;
    property USBEN : TBits_1 read getUSBEN write setUSBEN;
    property USBEN_SOFEN : TBits_1 read getUSBEN_SOFEN write setUSBEN_SOFEN;
    property USBRST : TBits_1 read getUSBRST write setUSBRST;
  end;
  TUSB_U1ADDR = record
  private
    function  getDEVADDR : TBits_7; assembler; nostackframe; inline;
    function  getDEVADDR0 : TBits_1; assembler; nostackframe; inline;
    function  getDEVADDR1 : TBits_1; assembler; nostackframe; inline;
    function  getDEVADDR2 : TBits_1; assembler; nostackframe; inline;
    function  getDEVADDR3 : TBits_1; assembler; nostackframe; inline;
    function  getDEVADDR4 : TBits_1; assembler; nostackframe; inline;
    function  getDEVADDR5 : TBits_1; assembler; nostackframe; inline;
    function  getDEVADDR6 : TBits_1; assembler; nostackframe; inline;
    function  getLSPDEN : TBits_1; assembler; nostackframe; inline;
    procedure setDEVADDR(thebits : TBits_7); assembler; nostackframe; inline;
    procedure setDEVADDR0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDEVADDR1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDEVADDR2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDEVADDR3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDEVADDR4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDEVADDR5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDEVADDR6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLSPDEN(thebits : TBits_1); assembler; nostackframe; inline;
  public
    procedure clearDEVADDR0;
    procedure clearDEVADDR1;
    procedure clearDEVADDR2;
    procedure clearDEVADDR3;
    procedure clearDEVADDR4;
    procedure clearDEVADDR5;
    procedure clearDEVADDR6;
    procedure clearLSPDEN;
    procedure setDEVADDR0;
    procedure setDEVADDR1;
    procedure setDEVADDR2;
    procedure setDEVADDR3;
    procedure setDEVADDR4;
    procedure setDEVADDR5;
    procedure setDEVADDR6;
    procedure setLSPDEN;
    property DEVADDR : TBits_7 read getDEVADDR write setDEVADDR;
    property DEVADDR0 : TBits_1 read getDEVADDR0 write setDEVADDR0;
    property DEVADDR1 : TBits_1 read getDEVADDR1 write setDEVADDR1;
    property DEVADDR2 : TBits_1 read getDEVADDR2 write setDEVADDR2;
    property DEVADDR3 : TBits_1 read getDEVADDR3 write setDEVADDR3;
    property DEVADDR4 : TBits_1 read getDEVADDR4 write setDEVADDR4;
    property DEVADDR5 : TBits_1 read getDEVADDR5 write setDEVADDR5;
    property DEVADDR6 : TBits_1 read getDEVADDR6 write setDEVADDR6;
    property LSPDEN : TBits_1 read getLSPDEN write setLSPDEN;
  end;
  TUSB_U1FRML = record
  private
    function  getFRM0 : TBits_1; assembler; nostackframe; inline;
    function  getFRM1 : TBits_1; assembler; nostackframe; inline;
    function  getFRM2 : TBits_1; assembler; nostackframe; inline;
    function  getFRM3 : TBits_1; assembler; nostackframe; inline;
    function  getFRM4 : TBits_1; assembler; nostackframe; inline;
    function  getFRM5 : TBits_1; assembler; nostackframe; inline;
    function  getFRM6 : TBits_1; assembler; nostackframe; inline;
    function  getFRM7 : TBits_1; assembler; nostackframe; inline;
    function  getFRML : TBits_8; assembler; nostackframe; inline;
    procedure setFRM0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRM1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRM2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRM3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRM4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRM5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRM6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRM7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRML(thebits : TBits_8); assembler; nostackframe; inline;
  public
    procedure clearFRM0;
    procedure clearFRM1;
    procedure clearFRM2;
    procedure clearFRM3;
    procedure clearFRM4;
    procedure clearFRM5;
    procedure clearFRM6;
    procedure clearFRM7;
    procedure setFRM0;
    procedure setFRM1;
    procedure setFRM2;
    procedure setFRM3;
    procedure setFRM4;
    procedure setFRM5;
    procedure setFRM6;
    procedure setFRM7;
    property FRM0 : TBits_1 read getFRM0 write setFRM0;
    property FRM1 : TBits_1 read getFRM1 write setFRM1;
    property FRM2 : TBits_1 read getFRM2 write setFRM2;
    property FRM3 : TBits_1 read getFRM3 write setFRM3;
    property FRM4 : TBits_1 read getFRM4 write setFRM4;
    property FRM5 : TBits_1 read getFRM5 write setFRM5;
    property FRM6 : TBits_1 read getFRM6 write setFRM6;
    property FRM7 : TBits_1 read getFRM7 write setFRM7;
    property FRML : TBits_8 read getFRML write setFRML;
  end;
  TUSB_U1FRMH = record
  private
    function  getFRM10 : TBits_1; assembler; nostackframe; inline;
    function  getFRM8 : TBits_1; assembler; nostackframe; inline;
    function  getFRM9 : TBits_1; assembler; nostackframe; inline;
    function  getFRMH : TBits_3; assembler; nostackframe; inline;
    procedure setFRM10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRM8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRM9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFRMH(thebits : TBits_3); assembler; nostackframe; inline;
  public
    procedure clearFRM10;
    procedure clearFRM8;
    procedure clearFRM9;
    procedure setFRM10;
    procedure setFRM8;
    procedure setFRM9;
    property FRM10 : TBits_1 read getFRM10 write setFRM10;
    property FRM8 : TBits_1 read getFRM8 write setFRM8;
    property FRM9 : TBits_1 read getFRM9 write setFRM9;
    property FRMH : TBits_3 read getFRMH write setFRMH;
  end;
  TUSB_U1TOK = record
  private
    function  getEP : TBits_4; assembler; nostackframe; inline;
    function  getEP0 : TBits_1; assembler; nostackframe; inline;
    function  getEP1 : TBits_1; assembler; nostackframe; inline;
    function  getEP2 : TBits_1; assembler; nostackframe; inline;
    function  getEP3 : TBits_1; assembler; nostackframe; inline;
    function  getPID : TBits_4; assembler; nostackframe; inline;
    function  getPID0 : TBits_1; assembler; nostackframe; inline;
    function  getPID1 : TBits_1; assembler; nostackframe; inline;
    function  getPID2 : TBits_1; assembler; nostackframe; inline;
    function  getPID3 : TBits_1; assembler; nostackframe; inline;
    procedure setEP(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setEP0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setEP1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setEP2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setEP3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPID(thebits : TBits_4); assembler; nostackframe; inline;
    procedure setPID0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPID1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPID2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPID3(thebits : TBits_1); assembler; nostackframe; inline;
  public
    procedure clearEP0;
    procedure clearEP1;
    procedure clearEP2;
    procedure clearEP3;
    procedure clearPID0;
    procedure clearPID1;
    procedure clearPID2;
    procedure clearPID3;
    procedure setEP0;
    procedure setEP1;
    procedure setEP2;
    procedure setEP3;
    procedure setPID0;
    procedure setPID1;
    procedure setPID2;
    procedure setPID3;
    property EP : TBits_4 read getEP write setEP;
    property EP0 : TBits_1 read getEP0 write setEP0;
    property EP1 : TBits_1 read getEP1 write setEP1;
    property EP2 : TBits_1 read getEP2 write setEP2;
    property EP3 : TBits_1 read getEP3 write setEP3;
    property PID : TBits_4 read getPID write setPID;
    property PID0 : TBits_1 read getPID0 write setPID0;
    property PID1 : TBits_1 read getPID1 write setPID1;
    property PID2 : TBits_1 read getPID2 write setPID2;
    property PID3 : TBits_1 read getPID3 write setPID3;
  end;
type
  TUSBRegisters = record
    U1OTGIR : longWord;
    U1OTGIRCLR : longWord;
    U1OTGIE : longWord;
    U1OTGIECLR : longWord;
    U1OTGIESET : longWord;
    U1OTGIEINV : longWord;
    U1OTGSTAT : longWord;
    U1OTGSTATCLR : longWord;
    U1OTGCON : longWord;
    U1OTGCONCLR : longWord;
    U1OTGCONSET : longWord;
    U1OTGCONINV : longWord;
    U1PWRC : longWord;
    U1PWRCCLR : longWord;
    U1PWRCSET : longWord;
    U1PWRCINV : longWord;
    U1IRbits : TUSB_U1IR;
    U1IR : longWord;
    U1IRCLR : longWord;
    U1IEbits : TUSB_U1IE;
    U1IE : longWord;
    U1IECLR : longWord;
    U1IESET : longWord;
    U1IEINV : longWord;
    U1EIRbits : TUSB_U1EIR;
    U1EIR : longWord;
    U1EIRCLR : longWord;
    U1EIEbits : TUSB_U1EIE;
    U1EIE : longWord;
    U1EIECLR : longWord;
    U1EIESET : longWord;
    U1EIEINV : longWord;
    U1STATbits : TUSB_U1STAT;
    U1STAT : longWord;
    U1STATCLR : longWord;
    U1STATSET : longWord;
    U1STATINV : longWord;
    U1CONbits : TUSB_U1CON;
    U1CON : longWord;
    U1CONCLR : longWord;
    U1CONSET : longWord;
    U1CONINV : longWord;
    U1ADDRbits : TUSB_U1ADDR;
    U1ADDR : longWord;
    U1ADDRCLR : longWord;
    U1ADDRSET : longWord;
    U1ADDRINV : longWord;
    U1BDTP1 : longWord;
    U1BDTP1CLR : longWord;
    U1BDTP1SET : longWord;
    U1BDTP1INV : longWord;
    U1FRMLbits : TUSB_U1FRML;
    U1FRML : longWord;
    U1FRMLCLR : longWord;
    U1FRMLSET : longWord;
    U1FRMLINV : longWord;
    U1FRMHbits : TUSB_U1FRMH;
    U1FRMH : longWord;
    U1FRMHCLR : longWord;
    U1FRMHSET : longWord;
    U1FRMHINV : longWord;
    U1TOKbits : TUSB_U1TOK;
    U1TOK : longWord;
    U1TOKCLR : longWord;
    U1TOKSET : longWord;
    U1TOKINV : longWord;
    U1SOF : longWord;
    U1SOFCLR : longWord;
    U1SOFSET : longWord;
    U1SOFINV : longWord;
    U1BDTP2 : longWord;
    U1BDTP2CLR : longWord;
    U1BDTP2SET : longWord;
    U1BDTP2INV : longWord;
    U1BDTP3 : longWord;
    U1BDTP3CLR : longWord;
    U1BDTP3SET : longWord;
    U1BDTP3INV : longWord;
    U1CNFG1 : longWord;
    U1CNFG1CLR : longWord;
    U1CNFG1SET : longWord;
    U1CNFG1INV : longWord;
    U1EP0 : longWord;
    U1EP0CLR : longWord;
    U1EP0SET : longWord;
    U1EP0INV : longWord;
    U1EP1 : longWord;
    U1EP1CLR : longWord;
    U1EP1SET : longWord;
    U1EP1INV : longWord;
    U1EP2 : longWord;
    U1EP2CLR : longWord;
    U1EP2SET : longWord;
    U1EP2INV : longWord;
    U1EP3 : longWord;
    U1EP3CLR : longWord;
    U1EP3SET : longWord;
    U1EP3INV : longWord;
    U1EP4 : longWord;
    U1EP4CLR : longWord;
    U1EP4SET : longWord;
    U1EP4INV : longWord;
    U1EP5 : longWord;
    U1EP5CLR : longWord;
    U1EP5SET : longWord;
    U1EP5INV : longWord;
    U1EP6 : longWord;
    U1EP6CLR : longWord;
    U1EP6SET : longWord;
    U1EP6INV : longWord;
    U1EP7 : longWord;
    U1EP7CLR : longWord;
    U1EP7SET : longWord;
    U1EP7INV : longWord;
    U1EP8 : longWord;
    U1EP8CLR : longWord;
    U1EP8SET : longWord;
    U1EP8INV : longWord;
    U1EP9 : longWord;
    U1EP9CLR : longWord;
    U1EP9SET : longWord;
    U1EP9INV : longWord;
    U1EP10 : longWord;
    U1EP10CLR : longWord;
    U1EP10SET : longWord;
    U1EP10INV : longWord;
    U1EP11 : longWord;
    U1EP11CLR : longWord;
    U1EP11SET : longWord;
    U1EP11INV : longWord;
    U1EP12 : longWord;
    U1EP12CLR : longWord;
    U1EP12SET : longWord;
    U1EP12INV : longWord;
    U1EP13 : longWord;
    U1EP13CLR : longWord;
    U1EP13SET : longWord;
    U1EP13INV : longWord;
    U1EP14 : longWord;
    U1EP14CLR : longWord;
    U1EP14SET : longWord;
    U1EP14INV : longWord;
    U1EP15 : longWord;
    U1EP15CLR : longWord;
    U1EP15SET : longWord;
    U1EP15INV : longWord;
  end;
  TPORTB_TRISB = record
  private
    function  getTRISB0 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB1 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB10 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB11 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB12 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB13 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB14 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB15 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB2 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB3 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB4 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB5 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB6 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB7 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB8 : TBits_1; assembler; nostackframe; inline;
    function  getTRISB9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setTRISB0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISB9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearTRISB0;
    procedure clearTRISB10;
    procedure clearTRISB11;
    procedure clearTRISB12;
    procedure clearTRISB13;
    procedure clearTRISB14;
    procedure clearTRISB15;
    procedure clearTRISB1;
    procedure clearTRISB2;
    procedure clearTRISB3;
    procedure clearTRISB4;
    procedure clearTRISB5;
    procedure clearTRISB6;
    procedure clearTRISB7;
    procedure clearTRISB8;
    procedure clearTRISB9;
    procedure setTRISB0;
    procedure setTRISB10;
    procedure setTRISB11;
    procedure setTRISB12;
    procedure setTRISB13;
    procedure setTRISB14;
    procedure setTRISB15;
    procedure setTRISB1;
    procedure setTRISB2;
    procedure setTRISB3;
    procedure setTRISB4;
    procedure setTRISB5;
    procedure setTRISB6;
    procedure setTRISB7;
    procedure setTRISB8;
    procedure setTRISB9;
    property TRISB0 : TBits_1 read getTRISB0 write setTRISB0;
    property TRISB1 : TBits_1 read getTRISB1 write setTRISB1;
    property TRISB10 : TBits_1 read getTRISB10 write setTRISB10;
    property TRISB11 : TBits_1 read getTRISB11 write setTRISB11;
    property TRISB12 : TBits_1 read getTRISB12 write setTRISB12;
    property TRISB13 : TBits_1 read getTRISB13 write setTRISB13;
    property TRISB14 : TBits_1 read getTRISB14 write setTRISB14;
    property TRISB15 : TBits_1 read getTRISB15 write setTRISB15;
    property TRISB2 : TBits_1 read getTRISB2 write setTRISB2;
    property TRISB3 : TBits_1 read getTRISB3 write setTRISB3;
    property TRISB4 : TBits_1 read getTRISB4 write setTRISB4;
    property TRISB5 : TBits_1 read getTRISB5 write setTRISB5;
    property TRISB6 : TBits_1 read getTRISB6 write setTRISB6;
    property TRISB7 : TBits_1 read getTRISB7 write setTRISB7;
    property TRISB8 : TBits_1 read getTRISB8 write setTRISB8;
    property TRISB9 : TBits_1 read getTRISB9 write setTRISB9;
    property w : TBits_32 read getw write setw;
  end;
  TPORTB_PORTB = record
  private
    function  getRB0 : TBits_1; assembler; nostackframe; inline;
    function  getRB1 : TBits_1; assembler; nostackframe; inline;
    function  getRB10 : TBits_1; assembler; nostackframe; inline;
    function  getRB11 : TBits_1; assembler; nostackframe; inline;
    function  getRB12 : TBits_1; assembler; nostackframe; inline;
    function  getRB13 : TBits_1; assembler; nostackframe; inline;
    function  getRB14 : TBits_1; assembler; nostackframe; inline;
    function  getRB15 : TBits_1; assembler; nostackframe; inline;
    function  getRB2 : TBits_1; assembler; nostackframe; inline;
    function  getRB3 : TBits_1; assembler; nostackframe; inline;
    function  getRB4 : TBits_1; assembler; nostackframe; inline;
    function  getRB5 : TBits_1; assembler; nostackframe; inline;
    function  getRB6 : TBits_1; assembler; nostackframe; inline;
    function  getRB7 : TBits_1; assembler; nostackframe; inline;
    function  getRB8 : TBits_1; assembler; nostackframe; inline;
    function  getRB9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setRB0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRB9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearRB0;
    procedure clearRB10;
    procedure clearRB11;
    procedure clearRB12;
    procedure clearRB13;
    procedure clearRB14;
    procedure clearRB15;
    procedure clearRB1;
    procedure clearRB2;
    procedure clearRB3;
    procedure clearRB4;
    procedure clearRB5;
    procedure clearRB6;
    procedure clearRB7;
    procedure clearRB8;
    procedure clearRB9;
    procedure setRB0;
    procedure setRB10;
    procedure setRB11;
    procedure setRB12;
    procedure setRB13;
    procedure setRB14;
    procedure setRB15;
    procedure setRB1;
    procedure setRB2;
    procedure setRB3;
    procedure setRB4;
    procedure setRB5;
    procedure setRB6;
    procedure setRB7;
    procedure setRB8;
    procedure setRB9;
    property RB0 : TBits_1 read getRB0 write setRB0;
    property RB1 : TBits_1 read getRB1 write setRB1;
    property RB10 : TBits_1 read getRB10 write setRB10;
    property RB11 : TBits_1 read getRB11 write setRB11;
    property RB12 : TBits_1 read getRB12 write setRB12;
    property RB13 : TBits_1 read getRB13 write setRB13;
    property RB14 : TBits_1 read getRB14 write setRB14;
    property RB15 : TBits_1 read getRB15 write setRB15;
    property RB2 : TBits_1 read getRB2 write setRB2;
    property RB3 : TBits_1 read getRB3 write setRB3;
    property RB4 : TBits_1 read getRB4 write setRB4;
    property RB5 : TBits_1 read getRB5 write setRB5;
    property RB6 : TBits_1 read getRB6 write setRB6;
    property RB7 : TBits_1 read getRB7 write setRB7;
    property RB8 : TBits_1 read getRB8 write setRB8;
    property RB9 : TBits_1 read getRB9 write setRB9;
    property w : TBits_32 read getw write setw;
  end;
  TPortB_bits=(RB0=0,RB1=1,RB2=2,RB3=3,RB4=4,RB5=5,RB6=6,RB7=7,RB8=8,RB9=9,RB10=10,RB11=11,RB12=12,RB13=13,RB14=14,RB15=15);
  TPortB_bitset = set of TPortB_bits;
  TPORTB_LATB = record
  private
    function  getLATB0 : TBits_1; assembler; nostackframe; inline;
    function  getLATB1 : TBits_1; assembler; nostackframe; inline;
    function  getLATB10 : TBits_1; assembler; nostackframe; inline;
    function  getLATB11 : TBits_1; assembler; nostackframe; inline;
    function  getLATB12 : TBits_1; assembler; nostackframe; inline;
    function  getLATB13 : TBits_1; assembler; nostackframe; inline;
    function  getLATB14 : TBits_1; assembler; nostackframe; inline;
    function  getLATB15 : TBits_1; assembler; nostackframe; inline;
    function  getLATB2 : TBits_1; assembler; nostackframe; inline;
    function  getLATB3 : TBits_1; assembler; nostackframe; inline;
    function  getLATB4 : TBits_1; assembler; nostackframe; inline;
    function  getLATB5 : TBits_1; assembler; nostackframe; inline;
    function  getLATB6 : TBits_1; assembler; nostackframe; inline;
    function  getLATB7 : TBits_1; assembler; nostackframe; inline;
    function  getLATB8 : TBits_1; assembler; nostackframe; inline;
    function  getLATB9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setLATB0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATB9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearLATB0;
    procedure clearLATB10;
    procedure clearLATB11;
    procedure clearLATB12;
    procedure clearLATB13;
    procedure clearLATB14;
    procedure clearLATB15;
    procedure clearLATB1;
    procedure clearLATB2;
    procedure clearLATB3;
    procedure clearLATB4;
    procedure clearLATB5;
    procedure clearLATB6;
    procedure clearLATB7;
    procedure clearLATB8;
    procedure clearLATB9;
    procedure setLATB0;
    procedure setLATB10;
    procedure setLATB11;
    procedure setLATB12;
    procedure setLATB13;
    procedure setLATB14;
    procedure setLATB15;
    procedure setLATB1;
    procedure setLATB2;
    procedure setLATB3;
    procedure setLATB4;
    procedure setLATB5;
    procedure setLATB6;
    procedure setLATB7;
    procedure setLATB8;
    procedure setLATB9;
    property LATB0 : TBits_1 read getLATB0 write setLATB0;
    property LATB1 : TBits_1 read getLATB1 write setLATB1;
    property LATB10 : TBits_1 read getLATB10 write setLATB10;
    property LATB11 : TBits_1 read getLATB11 write setLATB11;
    property LATB12 : TBits_1 read getLATB12 write setLATB12;
    property LATB13 : TBits_1 read getLATB13 write setLATB13;
    property LATB14 : TBits_1 read getLATB14 write setLATB14;
    property LATB15 : TBits_1 read getLATB15 write setLATB15;
    property LATB2 : TBits_1 read getLATB2 write setLATB2;
    property LATB3 : TBits_1 read getLATB3 write setLATB3;
    property LATB4 : TBits_1 read getLATB4 write setLATB4;
    property LATB5 : TBits_1 read getLATB5 write setLATB5;
    property LATB6 : TBits_1 read getLATB6 write setLATB6;
    property LATB7 : TBits_1 read getLATB7 write setLATB7;
    property LATB8 : TBits_1 read getLATB8 write setLATB8;
    property LATB9 : TBits_1 read getLATB9 write setLATB9;
    property w : TBits_32 read getw write setw;
  end;
  TPORTB_ODCB = record
  private
    function  getODCB0 : TBits_1; assembler; nostackframe; inline;
    function  getODCB1 : TBits_1; assembler; nostackframe; inline;
    function  getODCB10 : TBits_1; assembler; nostackframe; inline;
    function  getODCB11 : TBits_1; assembler; nostackframe; inline;
    function  getODCB12 : TBits_1; assembler; nostackframe; inline;
    function  getODCB13 : TBits_1; assembler; nostackframe; inline;
    function  getODCB14 : TBits_1; assembler; nostackframe; inline;
    function  getODCB15 : TBits_1; assembler; nostackframe; inline;
    function  getODCB2 : TBits_1; assembler; nostackframe; inline;
    function  getODCB3 : TBits_1; assembler; nostackframe; inline;
    function  getODCB4 : TBits_1; assembler; nostackframe; inline;
    function  getODCB5 : TBits_1; assembler; nostackframe; inline;
    function  getODCB6 : TBits_1; assembler; nostackframe; inline;
    function  getODCB7 : TBits_1; assembler; nostackframe; inline;
    function  getODCB8 : TBits_1; assembler; nostackframe; inline;
    function  getODCB9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setODCB0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCB9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearODCB0;
    procedure clearODCB10;
    procedure clearODCB11;
    procedure clearODCB12;
    procedure clearODCB13;
    procedure clearODCB14;
    procedure clearODCB15;
    procedure clearODCB1;
    procedure clearODCB2;
    procedure clearODCB3;
    procedure clearODCB4;
    procedure clearODCB5;
    procedure clearODCB6;
    procedure clearODCB7;
    procedure clearODCB8;
    procedure clearODCB9;
    procedure setODCB0;
    procedure setODCB10;
    procedure setODCB11;
    procedure setODCB12;
    procedure setODCB13;
    procedure setODCB14;
    procedure setODCB15;
    procedure setODCB1;
    procedure setODCB2;
    procedure setODCB3;
    procedure setODCB4;
    procedure setODCB5;
    procedure setODCB6;
    procedure setODCB7;
    procedure setODCB8;
    procedure setODCB9;
    property ODCB0 : TBits_1 read getODCB0 write setODCB0;
    property ODCB1 : TBits_1 read getODCB1 write setODCB1;
    property ODCB10 : TBits_1 read getODCB10 write setODCB10;
    property ODCB11 : TBits_1 read getODCB11 write setODCB11;
    property ODCB12 : TBits_1 read getODCB12 write setODCB12;
    property ODCB13 : TBits_1 read getODCB13 write setODCB13;
    property ODCB14 : TBits_1 read getODCB14 write setODCB14;
    property ODCB15 : TBits_1 read getODCB15 write setODCB15;
    property ODCB2 : TBits_1 read getODCB2 write setODCB2;
    property ODCB3 : TBits_1 read getODCB3 write setODCB3;
    property ODCB4 : TBits_1 read getODCB4 write setODCB4;
    property ODCB5 : TBits_1 read getODCB5 write setODCB5;
    property ODCB6 : TBits_1 read getODCB6 write setODCB6;
    property ODCB7 : TBits_1 read getODCB7 write setODCB7;
    property ODCB8 : TBits_1 read getODCB8 write setODCB8;
    property ODCB9 : TBits_1 read getODCB9 write setODCB9;
    property w : TBits_32 read getw write setw;
  end;
type
  TPORTBRegisters = record
    TRISBbits : TPORTB_TRISB;
    TRISB : longWord;
    TRISBCLR : longWord;
    TRISBSET : longWord;
    TRISBINV : longWord;
    PORTBbits : TPORTB_PORTB;
    PORTB : longWord;
    PORTBCLR : longWord;
    PORTBSET : longWord;
    PORTBINV : longWord;
    LATBbits : TPORTB_LATB;
    LATB : longWord;
    LATBCLR : longWord;
    LATBSET : longWord;
    LATBINV : longWord;
    ODCBbits : TPORTB_ODCB;
    ODCB : longWord;
    ODCBCLR : longWord;
    ODCBSET : longWord;
    ODCBINV : longWord;
  end;
  TPORTC_TRISC = record
  private
    function  getTRISC12 : TBits_1; assembler; nostackframe; inline;
    function  getTRISC13 : TBits_1; assembler; nostackframe; inline;
    function  getTRISC14 : TBits_1; assembler; nostackframe; inline;
    function  getTRISC15 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setTRISC12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISC13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISC14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISC15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearTRISC12;
    procedure clearTRISC13;
    procedure clearTRISC14;
    procedure clearTRISC15;
    procedure setTRISC12;
    procedure setTRISC13;
    procedure setTRISC14;
    procedure setTRISC15;
    property TRISC12 : TBits_1 read getTRISC12 write setTRISC12;
    property TRISC13 : TBits_1 read getTRISC13 write setTRISC13;
    property TRISC14 : TBits_1 read getTRISC14 write setTRISC14;
    property TRISC15 : TBits_1 read getTRISC15 write setTRISC15;
    property w : TBits_32 read getw write setw;
  end;
  TPORTC_PORTC = record
  private
    function  getRC12 : TBits_1; assembler; nostackframe; inline;
    function  getRC13 : TBits_1; assembler; nostackframe; inline;
    function  getRC14 : TBits_1; assembler; nostackframe; inline;
    function  getRC15 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setRC12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRC13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRC14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRC15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearRC12;
    procedure clearRC13;
    procedure clearRC14;
    procedure clearRC15;
    procedure setRC12;
    procedure setRC13;
    procedure setRC14;
    procedure setRC15;
    property RC12 : TBits_1 read getRC12 write setRC12;
    property RC13 : TBits_1 read getRC13 write setRC13;
    property RC14 : TBits_1 read getRC14 write setRC14;
    property RC15 : TBits_1 read getRC15 write setRC15;
    property w : TBits_32 read getw write setw;
  end;
  TPortC_bits=(RC12=12,RC13=13,RC14=14,RC15=15);
  TPortC_bitset = set of TPortC_bits;
  TPORTC_LATC = record
  private
    function  getLATC12 : TBits_1; assembler; nostackframe; inline;
    function  getLATC13 : TBits_1; assembler; nostackframe; inline;
    function  getLATC14 : TBits_1; assembler; nostackframe; inline;
    function  getLATC15 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setLATC12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATC13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATC14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATC15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearLATC12;
    procedure clearLATC13;
    procedure clearLATC14;
    procedure clearLATC15;
    procedure setLATC12;
    procedure setLATC13;
    procedure setLATC14;
    procedure setLATC15;
    property LATC12 : TBits_1 read getLATC12 write setLATC12;
    property LATC13 : TBits_1 read getLATC13 write setLATC13;
    property LATC14 : TBits_1 read getLATC14 write setLATC14;
    property LATC15 : TBits_1 read getLATC15 write setLATC15;
    property w : TBits_32 read getw write setw;
  end;
  TPORTC_ODCC = record
  private
    function  getODCC12 : TBits_1; assembler; nostackframe; inline;
    function  getODCC13 : TBits_1; assembler; nostackframe; inline;
    function  getODCC14 : TBits_1; assembler; nostackframe; inline;
    function  getODCC15 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setODCC12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCC13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCC14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCC15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearODCC12;
    procedure clearODCC13;
    procedure clearODCC14;
    procedure clearODCC15;
    procedure setODCC12;
    procedure setODCC13;
    procedure setODCC14;
    procedure setODCC15;
    property ODCC12 : TBits_1 read getODCC12 write setODCC12;
    property ODCC13 : TBits_1 read getODCC13 write setODCC13;
    property ODCC14 : TBits_1 read getODCC14 write setODCC14;
    property ODCC15 : TBits_1 read getODCC15 write setODCC15;
    property w : TBits_32 read getw write setw;
  end;
type
  TPORTCRegisters = record
    TRISCbits : TPORTC_TRISC;
    TRISC : longWord;
    TRISCCLR : longWord;
    TRISCSET : longWord;
    TRISCINV : longWord;
    PORTCbits : TPORTC_PORTC;
    PORTC : longWord;
    PORTCCLR : longWord;
    PORTCSET : longWord;
    PORTCINV : longWord;
    LATCbits : TPORTC_LATC;
    LATC : longWord;
    LATCCLR : longWord;
    LATCSET : longWord;
    LATCINV : longWord;
    ODCCbits : TPORTC_ODCC;
    ODCC : longWord;
    ODCCCLR : longWord;
    ODCCSET : longWord;
    ODCCINV : longWord;
  end;
  TPORTD_TRISD = record
  private
    function  getTRISD0 : TBits_1; assembler; nostackframe; inline;
    function  getTRISD1 : TBits_1; assembler; nostackframe; inline;
    function  getTRISD10 : TBits_1; assembler; nostackframe; inline;
    function  getTRISD11 : TBits_1; assembler; nostackframe; inline;
    function  getTRISD2 : TBits_1; assembler; nostackframe; inline;
    function  getTRISD3 : TBits_1; assembler; nostackframe; inline;
    function  getTRISD4 : TBits_1; assembler; nostackframe; inline;
    function  getTRISD5 : TBits_1; assembler; nostackframe; inline;
    function  getTRISD6 : TBits_1; assembler; nostackframe; inline;
    function  getTRISD7 : TBits_1; assembler; nostackframe; inline;
    function  getTRISD8 : TBits_1; assembler; nostackframe; inline;
    function  getTRISD9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setTRISD0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISD1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISD10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISD11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISD2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISD3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISD4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISD5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISD6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISD7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISD8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISD9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearTRISD0;
    procedure clearTRISD10;
    procedure clearTRISD11;
    procedure clearTRISD1;
    procedure clearTRISD2;
    procedure clearTRISD3;
    procedure clearTRISD4;
    procedure clearTRISD5;
    procedure clearTRISD6;
    procedure clearTRISD7;
    procedure clearTRISD8;
    procedure clearTRISD9;
    procedure setTRISD0;
    procedure setTRISD10;
    procedure setTRISD11;
    procedure setTRISD1;
    procedure setTRISD2;
    procedure setTRISD3;
    procedure setTRISD4;
    procedure setTRISD5;
    procedure setTRISD6;
    procedure setTRISD7;
    procedure setTRISD8;
    procedure setTRISD9;
    property TRISD0 : TBits_1 read getTRISD0 write setTRISD0;
    property TRISD1 : TBits_1 read getTRISD1 write setTRISD1;
    property TRISD10 : TBits_1 read getTRISD10 write setTRISD10;
    property TRISD11 : TBits_1 read getTRISD11 write setTRISD11;
    property TRISD2 : TBits_1 read getTRISD2 write setTRISD2;
    property TRISD3 : TBits_1 read getTRISD3 write setTRISD3;
    property TRISD4 : TBits_1 read getTRISD4 write setTRISD4;
    property TRISD5 : TBits_1 read getTRISD5 write setTRISD5;
    property TRISD6 : TBits_1 read getTRISD6 write setTRISD6;
    property TRISD7 : TBits_1 read getTRISD7 write setTRISD7;
    property TRISD8 : TBits_1 read getTRISD8 write setTRISD8;
    property TRISD9 : TBits_1 read getTRISD9 write setTRISD9;
    property w : TBits_32 read getw write setw;
  end;
  TPORTD_PORTD = record
  private
    function  getRD0 : TBits_1; assembler; nostackframe; inline;
    function  getRD1 : TBits_1; assembler; nostackframe; inline;
    function  getRD10 : TBits_1; assembler; nostackframe; inline;
    function  getRD11 : TBits_1; assembler; nostackframe; inline;
    function  getRD2 : TBits_1; assembler; nostackframe; inline;
    function  getRD3 : TBits_1; assembler; nostackframe; inline;
    function  getRD4 : TBits_1; assembler; nostackframe; inline;
    function  getRD5 : TBits_1; assembler; nostackframe; inline;
    function  getRD6 : TBits_1; assembler; nostackframe; inline;
    function  getRD7 : TBits_1; assembler; nostackframe; inline;
    function  getRD8 : TBits_1; assembler; nostackframe; inline;
    function  getRD9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setRD0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRD1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRD10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRD11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRD2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRD3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRD4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRD5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRD6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRD7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRD8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRD9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearRD0;
    procedure clearRD10;
    procedure clearRD11;
    procedure clearRD1;
    procedure clearRD2;
    procedure clearRD3;
    procedure clearRD4;
    procedure clearRD5;
    procedure clearRD6;
    procedure clearRD7;
    procedure clearRD8;
    procedure clearRD9;
    procedure setRD0;
    procedure setRD10;
    procedure setRD11;
    procedure setRD1;
    procedure setRD2;
    procedure setRD3;
    procedure setRD4;
    procedure setRD5;
    procedure setRD6;
    procedure setRD7;
    procedure setRD8;
    procedure setRD9;
    property RD0 : TBits_1 read getRD0 write setRD0;
    property RD1 : TBits_1 read getRD1 write setRD1;
    property RD10 : TBits_1 read getRD10 write setRD10;
    property RD11 : TBits_1 read getRD11 write setRD11;
    property RD2 : TBits_1 read getRD2 write setRD2;
    property RD3 : TBits_1 read getRD3 write setRD3;
    property RD4 : TBits_1 read getRD4 write setRD4;
    property RD5 : TBits_1 read getRD5 write setRD5;
    property RD6 : TBits_1 read getRD6 write setRD6;
    property RD7 : TBits_1 read getRD7 write setRD7;
    property RD8 : TBits_1 read getRD8 write setRD8;
    property RD9 : TBits_1 read getRD9 write setRD9;
    property w : TBits_32 read getw write setw;
  end;
  TPortD_bits=(RD0=0,RD1=1,RD2=2,RD3=3,RD4=4,RD5=5,RD6=6,RD7=7,RD8=8,RD9=9,RD10=10,RD11=11);
  TPortD_bitset = set of TPortD_bits;
  TPORTD_LATD = record
  private
    function  getLATD0 : TBits_1; assembler; nostackframe; inline;
    function  getLATD1 : TBits_1; assembler; nostackframe; inline;
    function  getLATD10 : TBits_1; assembler; nostackframe; inline;
    function  getLATD11 : TBits_1; assembler; nostackframe; inline;
    function  getLATD2 : TBits_1; assembler; nostackframe; inline;
    function  getLATD3 : TBits_1; assembler; nostackframe; inline;
    function  getLATD4 : TBits_1; assembler; nostackframe; inline;
    function  getLATD5 : TBits_1; assembler; nostackframe; inline;
    function  getLATD6 : TBits_1; assembler; nostackframe; inline;
    function  getLATD7 : TBits_1; assembler; nostackframe; inline;
    function  getLATD8 : TBits_1; assembler; nostackframe; inline;
    function  getLATD9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setLATD0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATD1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATD10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATD11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATD2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATD3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATD4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATD5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATD6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATD7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATD8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATD9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearLATD0;
    procedure clearLATD10;
    procedure clearLATD11;
    procedure clearLATD1;
    procedure clearLATD2;
    procedure clearLATD3;
    procedure clearLATD4;
    procedure clearLATD5;
    procedure clearLATD6;
    procedure clearLATD7;
    procedure clearLATD8;
    procedure clearLATD9;
    procedure setLATD0;
    procedure setLATD10;
    procedure setLATD11;
    procedure setLATD1;
    procedure setLATD2;
    procedure setLATD3;
    procedure setLATD4;
    procedure setLATD5;
    procedure setLATD6;
    procedure setLATD7;
    procedure setLATD8;
    procedure setLATD9;
    property LATD0 : TBits_1 read getLATD0 write setLATD0;
    property LATD1 : TBits_1 read getLATD1 write setLATD1;
    property LATD10 : TBits_1 read getLATD10 write setLATD10;
    property LATD11 : TBits_1 read getLATD11 write setLATD11;
    property LATD2 : TBits_1 read getLATD2 write setLATD2;
    property LATD3 : TBits_1 read getLATD3 write setLATD3;
    property LATD4 : TBits_1 read getLATD4 write setLATD4;
    property LATD5 : TBits_1 read getLATD5 write setLATD5;
    property LATD6 : TBits_1 read getLATD6 write setLATD6;
    property LATD7 : TBits_1 read getLATD7 write setLATD7;
    property LATD8 : TBits_1 read getLATD8 write setLATD8;
    property LATD9 : TBits_1 read getLATD9 write setLATD9;
    property w : TBits_32 read getw write setw;
  end;
  TPORTD_ODCD = record
  private
    function  getODCD0 : TBits_1; assembler; nostackframe; inline;
    function  getODCD1 : TBits_1; assembler; nostackframe; inline;
    function  getODCD10 : TBits_1; assembler; nostackframe; inline;
    function  getODCD11 : TBits_1; assembler; nostackframe; inline;
    function  getODCD2 : TBits_1; assembler; nostackframe; inline;
    function  getODCD3 : TBits_1; assembler; nostackframe; inline;
    function  getODCD4 : TBits_1; assembler; nostackframe; inline;
    function  getODCD5 : TBits_1; assembler; nostackframe; inline;
    function  getODCD6 : TBits_1; assembler; nostackframe; inline;
    function  getODCD7 : TBits_1; assembler; nostackframe; inline;
    function  getODCD8 : TBits_1; assembler; nostackframe; inline;
    function  getODCD9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setODCD0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCD1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCD10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCD11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCD2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCD3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCD4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCD5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCD6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCD7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCD8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCD9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearODCD0;
    procedure clearODCD10;
    procedure clearODCD11;
    procedure clearODCD1;
    procedure clearODCD2;
    procedure clearODCD3;
    procedure clearODCD4;
    procedure clearODCD5;
    procedure clearODCD6;
    procedure clearODCD7;
    procedure clearODCD8;
    procedure clearODCD9;
    procedure setODCD0;
    procedure setODCD10;
    procedure setODCD11;
    procedure setODCD1;
    procedure setODCD2;
    procedure setODCD3;
    procedure setODCD4;
    procedure setODCD5;
    procedure setODCD6;
    procedure setODCD7;
    procedure setODCD8;
    procedure setODCD9;
    property ODCD0 : TBits_1 read getODCD0 write setODCD0;
    property ODCD1 : TBits_1 read getODCD1 write setODCD1;
    property ODCD10 : TBits_1 read getODCD10 write setODCD10;
    property ODCD11 : TBits_1 read getODCD11 write setODCD11;
    property ODCD2 : TBits_1 read getODCD2 write setODCD2;
    property ODCD3 : TBits_1 read getODCD3 write setODCD3;
    property ODCD4 : TBits_1 read getODCD4 write setODCD4;
    property ODCD5 : TBits_1 read getODCD5 write setODCD5;
    property ODCD6 : TBits_1 read getODCD6 write setODCD6;
    property ODCD7 : TBits_1 read getODCD7 write setODCD7;
    property ODCD8 : TBits_1 read getODCD8 write setODCD8;
    property ODCD9 : TBits_1 read getODCD9 write setODCD9;
    property w : TBits_32 read getw write setw;
  end;
type
  TPORTDRegisters = record
    TRISDbits : TPORTD_TRISD;
    TRISD : longWord;
    TRISDCLR : longWord;
    TRISDSET : longWord;
    TRISDINV : longWord;
    PORTDbits : TPORTD_PORTD;
    PORTD : longWord;
    PORTDCLR : longWord;
    PORTDSET : longWord;
    PORTDINV : longWord;
    LATDbits : TPORTD_LATD;
    LATD : longWord;
    LATDCLR : longWord;
    LATDSET : longWord;
    LATDINV : longWord;
    ODCDbits : TPORTD_ODCD;
    ODCD : longWord;
    ODCDCLR : longWord;
    ODCDSET : longWord;
    ODCDINV : longWord;
  end;
  TPORTE_TRISE = record
  private
    function  getTRISE0 : TBits_1; assembler; nostackframe; inline;
    function  getTRISE1 : TBits_1; assembler; nostackframe; inline;
    function  getTRISE2 : TBits_1; assembler; nostackframe; inline;
    function  getTRISE3 : TBits_1; assembler; nostackframe; inline;
    function  getTRISE4 : TBits_1; assembler; nostackframe; inline;
    function  getTRISE5 : TBits_1; assembler; nostackframe; inline;
    function  getTRISE6 : TBits_1; assembler; nostackframe; inline;
    function  getTRISE7 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setTRISE0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISE1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISE2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISE3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISE4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISE5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISE6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISE7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearTRISE0;
    procedure clearTRISE1;
    procedure clearTRISE2;
    procedure clearTRISE3;
    procedure clearTRISE4;
    procedure clearTRISE5;
    procedure clearTRISE6;
    procedure clearTRISE7;
    procedure setTRISE0;
    procedure setTRISE1;
    procedure setTRISE2;
    procedure setTRISE3;
    procedure setTRISE4;
    procedure setTRISE5;
    procedure setTRISE6;
    procedure setTRISE7;
    property TRISE0 : TBits_1 read getTRISE0 write setTRISE0;
    property TRISE1 : TBits_1 read getTRISE1 write setTRISE1;
    property TRISE2 : TBits_1 read getTRISE2 write setTRISE2;
    property TRISE3 : TBits_1 read getTRISE3 write setTRISE3;
    property TRISE4 : TBits_1 read getTRISE4 write setTRISE4;
    property TRISE5 : TBits_1 read getTRISE5 write setTRISE5;
    property TRISE6 : TBits_1 read getTRISE6 write setTRISE6;
    property TRISE7 : TBits_1 read getTRISE7 write setTRISE7;
    property w : TBits_32 read getw write setw;
  end;
  TPORTE_PORTE = record
  private
    function  getRE0 : TBits_1; assembler; nostackframe; inline;
    function  getRE1 : TBits_1; assembler; nostackframe; inline;
    function  getRE2 : TBits_1; assembler; nostackframe; inline;
    function  getRE3 : TBits_1; assembler; nostackframe; inline;
    function  getRE4 : TBits_1; assembler; nostackframe; inline;
    function  getRE5 : TBits_1; assembler; nostackframe; inline;
    function  getRE6 : TBits_1; assembler; nostackframe; inline;
    function  getRE7 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setRE0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRE1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRE2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRE3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRE4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRE5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRE6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRE7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearRE0;
    procedure clearRE1;
    procedure clearRE2;
    procedure clearRE3;
    procedure clearRE4;
    procedure clearRE5;
    procedure clearRE6;
    procedure clearRE7;
    procedure setRE0;
    procedure setRE1;
    procedure setRE2;
    procedure setRE3;
    procedure setRE4;
    procedure setRE5;
    procedure setRE6;
    procedure setRE7;
    property RE0 : TBits_1 read getRE0 write setRE0;
    property RE1 : TBits_1 read getRE1 write setRE1;
    property RE2 : TBits_1 read getRE2 write setRE2;
    property RE3 : TBits_1 read getRE3 write setRE3;
    property RE4 : TBits_1 read getRE4 write setRE4;
    property RE5 : TBits_1 read getRE5 write setRE5;
    property RE6 : TBits_1 read getRE6 write setRE6;
    property RE7 : TBits_1 read getRE7 write setRE7;
    property w : TBits_32 read getw write setw;
  end;
  TPortE_bits=(RE0=0,RE1=1,RE2=2,RE3=3,RE4=4,RE5=5,RE6=6,RE7=7);
  TPortE_bitset = set of TPortE_bits;
  TPORTE_LATE = record
  private
    function  getLATE0 : TBits_1; assembler; nostackframe; inline;
    function  getLATE1 : TBits_1; assembler; nostackframe; inline;
    function  getLATE2 : TBits_1; assembler; nostackframe; inline;
    function  getLATE3 : TBits_1; assembler; nostackframe; inline;
    function  getLATE4 : TBits_1; assembler; nostackframe; inline;
    function  getLATE5 : TBits_1; assembler; nostackframe; inline;
    function  getLATE6 : TBits_1; assembler; nostackframe; inline;
    function  getLATE7 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setLATE0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATE1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATE2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATE3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATE4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATE5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATE6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATE7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearLATE0;
    procedure clearLATE1;
    procedure clearLATE2;
    procedure clearLATE3;
    procedure clearLATE4;
    procedure clearLATE5;
    procedure clearLATE6;
    procedure clearLATE7;
    procedure setLATE0;
    procedure setLATE1;
    procedure setLATE2;
    procedure setLATE3;
    procedure setLATE4;
    procedure setLATE5;
    procedure setLATE6;
    procedure setLATE7;
    property LATE0 : TBits_1 read getLATE0 write setLATE0;
    property LATE1 : TBits_1 read getLATE1 write setLATE1;
    property LATE2 : TBits_1 read getLATE2 write setLATE2;
    property LATE3 : TBits_1 read getLATE3 write setLATE3;
    property LATE4 : TBits_1 read getLATE4 write setLATE4;
    property LATE5 : TBits_1 read getLATE5 write setLATE5;
    property LATE6 : TBits_1 read getLATE6 write setLATE6;
    property LATE7 : TBits_1 read getLATE7 write setLATE7;
    property w : TBits_32 read getw write setw;
  end;
  TPORTE_ODCE = record
  private
    function  getODCE0 : TBits_1; assembler; nostackframe; inline;
    function  getODCE1 : TBits_1; assembler; nostackframe; inline;
    function  getODCE2 : TBits_1; assembler; nostackframe; inline;
    function  getODCE3 : TBits_1; assembler; nostackframe; inline;
    function  getODCE4 : TBits_1; assembler; nostackframe; inline;
    function  getODCE5 : TBits_1; assembler; nostackframe; inline;
    function  getODCE6 : TBits_1; assembler; nostackframe; inline;
    function  getODCE7 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setODCE0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCE1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCE2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCE3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCE4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCE5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCE6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCE7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearODCE0;
    procedure clearODCE1;
    procedure clearODCE2;
    procedure clearODCE3;
    procedure clearODCE4;
    procedure clearODCE5;
    procedure clearODCE6;
    procedure clearODCE7;
    procedure setODCE0;
    procedure setODCE1;
    procedure setODCE2;
    procedure setODCE3;
    procedure setODCE4;
    procedure setODCE5;
    procedure setODCE6;
    procedure setODCE7;
    property ODCE0 : TBits_1 read getODCE0 write setODCE0;
    property ODCE1 : TBits_1 read getODCE1 write setODCE1;
    property ODCE2 : TBits_1 read getODCE2 write setODCE2;
    property ODCE3 : TBits_1 read getODCE3 write setODCE3;
    property ODCE4 : TBits_1 read getODCE4 write setODCE4;
    property ODCE5 : TBits_1 read getODCE5 write setODCE5;
    property ODCE6 : TBits_1 read getODCE6 write setODCE6;
    property ODCE7 : TBits_1 read getODCE7 write setODCE7;
    property w : TBits_32 read getw write setw;
  end;
type
  TPORTERegisters = record
    TRISEbits : TPORTE_TRISE;
    TRISE : longWord;
    TRISECLR : longWord;
    TRISESET : longWord;
    TRISEINV : longWord;
    PORTEbits : TPORTE_PORTE;
    PORTE : longWord;
    PORTECLR : longWord;
    PORTESET : longWord;
    PORTEINV : longWord;
    LATEbits : TPORTE_LATE;
    LATE : longWord;
    LATECLR : longWord;
    LATESET : longWord;
    LATEINV : longWord;
    ODCEbits : TPORTE_ODCE;
    ODCE : longWord;
    ODCECLR : longWord;
    ODCESET : longWord;
    ODCEINV : longWord;
  end;
  TPORTF_TRISF = record
  private
    function  getTRISF0 : TBits_1; assembler; nostackframe; inline;
    function  getTRISF1 : TBits_1; assembler; nostackframe; inline;
    function  getTRISF3 : TBits_1; assembler; nostackframe; inline;
    function  getTRISF4 : TBits_1; assembler; nostackframe; inline;
    function  getTRISF5 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setTRISF0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISF1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISF3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISF4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISF5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearTRISF0;
    procedure clearTRISF1;
    procedure clearTRISF3;
    procedure clearTRISF4;
    procedure clearTRISF5;
    procedure setTRISF0;
    procedure setTRISF1;
    procedure setTRISF3;
    procedure setTRISF4;
    procedure setTRISF5;
    property TRISF0 : TBits_1 read getTRISF0 write setTRISF0;
    property TRISF1 : TBits_1 read getTRISF1 write setTRISF1;
    property TRISF3 : TBits_1 read getTRISF3 write setTRISF3;
    property TRISF4 : TBits_1 read getTRISF4 write setTRISF4;
    property TRISF5 : TBits_1 read getTRISF5 write setTRISF5;
    property w : TBits_32 read getw write setw;
  end;
  TPORTF_PORTF = record
  private
    function  getRF0 : TBits_1; assembler; nostackframe; inline;
    function  getRF1 : TBits_1; assembler; nostackframe; inline;
    function  getRF3 : TBits_1; assembler; nostackframe; inline;
    function  getRF4 : TBits_1; assembler; nostackframe; inline;
    function  getRF5 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setRF0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRF1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRF3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRF4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRF5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearRF0;
    procedure clearRF1;
    procedure clearRF3;
    procedure clearRF4;
    procedure clearRF5;
    procedure setRF0;
    procedure setRF1;
    procedure setRF3;
    procedure setRF4;
    procedure setRF5;
    property RF0 : TBits_1 read getRF0 write setRF0;
    property RF1 : TBits_1 read getRF1 write setRF1;
    property RF3 : TBits_1 read getRF3 write setRF3;
    property RF4 : TBits_1 read getRF4 write setRF4;
    property RF5 : TBits_1 read getRF5 write setRF5;
    property w : TBits_32 read getw write setw;
  end;
  TPortF_bits=(RF0=0,RF1=1,RF3=3,RF4=4,RF5=5);
  TPortF_bitset = set of TPortF_bits;
  TPORTF_LATF = record
  private
    function  getLATF0 : TBits_1; assembler; nostackframe; inline;
    function  getLATF1 : TBits_1; assembler; nostackframe; inline;
    function  getLATF3 : TBits_1; assembler; nostackframe; inline;
    function  getLATF4 : TBits_1; assembler; nostackframe; inline;
    function  getLATF5 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setLATF0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATF1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATF3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATF4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATF5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearLATF0;
    procedure clearLATF1;
    procedure clearLATF3;
    procedure clearLATF4;
    procedure clearLATF5;
    procedure setLATF0;
    procedure setLATF1;
    procedure setLATF3;
    procedure setLATF4;
    procedure setLATF5;
    property LATF0 : TBits_1 read getLATF0 write setLATF0;
    property LATF1 : TBits_1 read getLATF1 write setLATF1;
    property LATF3 : TBits_1 read getLATF3 write setLATF3;
    property LATF4 : TBits_1 read getLATF4 write setLATF4;
    property LATF5 : TBits_1 read getLATF5 write setLATF5;
    property w : TBits_32 read getw write setw;
  end;
  TPORTF_ODCF = record
  private
    function  getODCF0 : TBits_1; assembler; nostackframe; inline;
    function  getODCF1 : TBits_1; assembler; nostackframe; inline;
    function  getODCF3 : TBits_1; assembler; nostackframe; inline;
    function  getODCF4 : TBits_1; assembler; nostackframe; inline;
    function  getODCF5 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setODCF0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCF1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCF3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCF4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCF5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearODCF0;
    procedure clearODCF1;
    procedure clearODCF3;
    procedure clearODCF4;
    procedure clearODCF5;
    procedure setODCF0;
    procedure setODCF1;
    procedure setODCF3;
    procedure setODCF4;
    procedure setODCF5;
    property ODCF0 : TBits_1 read getODCF0 write setODCF0;
    property ODCF1 : TBits_1 read getODCF1 write setODCF1;
    property ODCF3 : TBits_1 read getODCF3 write setODCF3;
    property ODCF4 : TBits_1 read getODCF4 write setODCF4;
    property ODCF5 : TBits_1 read getODCF5 write setODCF5;
    property w : TBits_32 read getw write setw;
  end;
type
  TPORTFRegisters = record
    TRISFbits : TPORTF_TRISF;
    TRISF : longWord;
    TRISFCLR : longWord;
    TRISFSET : longWord;
    TRISFINV : longWord;
    PORTFbits : TPORTF_PORTF;
    PORTF : longWord;
    PORTFCLR : longWord;
    PORTFSET : longWord;
    PORTFINV : longWord;
    LATFbits : TPORTF_LATF;
    LATF : longWord;
    LATFCLR : longWord;
    LATFSET : longWord;
    LATFINV : longWord;
    ODCFbits : TPORTF_ODCF;
    ODCF : longWord;
    ODCFCLR : longWord;
    ODCFSET : longWord;
    ODCFINV : longWord;
  end;
  TPORTG_TRISG = record
  private
    function  getTRISG2 : TBits_1; assembler; nostackframe; inline;
    function  getTRISG3 : TBits_1; assembler; nostackframe; inline;
    function  getTRISG6 : TBits_1; assembler; nostackframe; inline;
    function  getTRISG7 : TBits_1; assembler; nostackframe; inline;
    function  getTRISG8 : TBits_1; assembler; nostackframe; inline;
    function  getTRISG9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setTRISG2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISG3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISG6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISG7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISG8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setTRISG9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearTRISG2;
    procedure clearTRISG3;
    procedure clearTRISG6;
    procedure clearTRISG7;
    procedure clearTRISG8;
    procedure clearTRISG9;
    procedure setTRISG2;
    procedure setTRISG3;
    procedure setTRISG6;
    procedure setTRISG7;
    procedure setTRISG8;
    procedure setTRISG9;
    property TRISG2 : TBits_1 read getTRISG2 write setTRISG2;
    property TRISG3 : TBits_1 read getTRISG3 write setTRISG3;
    property TRISG6 : TBits_1 read getTRISG6 write setTRISG6;
    property TRISG7 : TBits_1 read getTRISG7 write setTRISG7;
    property TRISG8 : TBits_1 read getTRISG8 write setTRISG8;
    property TRISG9 : TBits_1 read getTRISG9 write setTRISG9;
    property w : TBits_32 read getw write setw;
  end;
  TPORTG_PORTG = record
  private
    function  getRG2 : TBits_1; assembler; nostackframe; inline;
    function  getRG3 : TBits_1; assembler; nostackframe; inline;
    function  getRG6 : TBits_1; assembler; nostackframe; inline;
    function  getRG7 : TBits_1; assembler; nostackframe; inline;
    function  getRG8 : TBits_1; assembler; nostackframe; inline;
    function  getRG9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setRG2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRG3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRG6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRG7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRG8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setRG9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearRG2;
    procedure clearRG3;
    procedure clearRG6;
    procedure clearRG7;
    procedure clearRG8;
    procedure clearRG9;
    procedure setRG2;
    procedure setRG3;
    procedure setRG6;
    procedure setRG7;
    procedure setRG8;
    procedure setRG9;
    property RG2 : TBits_1 read getRG2 write setRG2;
    property RG3 : TBits_1 read getRG3 write setRG3;
    property RG6 : TBits_1 read getRG6 write setRG6;
    property RG7 : TBits_1 read getRG7 write setRG7;
    property RG8 : TBits_1 read getRG8 write setRG8;
    property RG9 : TBits_1 read getRG9 write setRG9;
    property w : TBits_32 read getw write setw;
  end;
  TPortG_bits=(RG2=2,RG3=3,RG6=6,RG7=7,RG8=8,RG9=9);
  TPortG_bitset = set of TPortG_bits;
  TPORTG_LATG = record
  private
    function  getLATG2 : TBits_1; assembler; nostackframe; inline;
    function  getLATG3 : TBits_1; assembler; nostackframe; inline;
    function  getLATG6 : TBits_1; assembler; nostackframe; inline;
    function  getLATG7 : TBits_1; assembler; nostackframe; inline;
    function  getLATG8 : TBits_1; assembler; nostackframe; inline;
    function  getLATG9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setLATG2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATG3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATG6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATG7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATG8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setLATG9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearLATG2;
    procedure clearLATG3;
    procedure clearLATG6;
    procedure clearLATG7;
    procedure clearLATG8;
    procedure clearLATG9;
    procedure setLATG2;
    procedure setLATG3;
    procedure setLATG6;
    procedure setLATG7;
    procedure setLATG8;
    procedure setLATG9;
    property LATG2 : TBits_1 read getLATG2 write setLATG2;
    property LATG3 : TBits_1 read getLATG3 write setLATG3;
    property LATG6 : TBits_1 read getLATG6 write setLATG6;
    property LATG7 : TBits_1 read getLATG7 write setLATG7;
    property LATG8 : TBits_1 read getLATG8 write setLATG8;
    property LATG9 : TBits_1 read getLATG9 write setLATG9;
    property w : TBits_32 read getw write setw;
  end;
  TPORTG_ODCG = record
  private
    function  getODCG2 : TBits_1; assembler; nostackframe; inline;
    function  getODCG3 : TBits_1; assembler; nostackframe; inline;
    function  getODCG6 : TBits_1; assembler; nostackframe; inline;
    function  getODCG7 : TBits_1; assembler; nostackframe; inline;
    function  getODCG8 : TBits_1; assembler; nostackframe; inline;
    function  getODCG9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setODCG2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCG3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCG6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCG7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCG8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setODCG9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearODCG2;
    procedure clearODCG3;
    procedure clearODCG6;
    procedure clearODCG7;
    procedure clearODCG8;
    procedure clearODCG9;
    procedure setODCG2;
    procedure setODCG3;
    procedure setODCG6;
    procedure setODCG7;
    procedure setODCG8;
    procedure setODCG9;
    property ODCG2 : TBits_1 read getODCG2 write setODCG2;
    property ODCG3 : TBits_1 read getODCG3 write setODCG3;
    property ODCG6 : TBits_1 read getODCG6 write setODCG6;
    property ODCG7 : TBits_1 read getODCG7 write setODCG7;
    property ODCG8 : TBits_1 read getODCG8 write setODCG8;
    property ODCG9 : TBits_1 read getODCG9 write setODCG9;
    property w : TBits_32 read getw write setw;
  end;
  TPORTG_CNCON = record
  private
    function  getON : TBits_1; assembler; nostackframe; inline;
    function  getSIDL : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setON(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearON;
    procedure clearSIDL;
    procedure setON;
    procedure setSIDL;
    property ON : TBits_1 read getON write setON;
    property SIDL : TBits_1 read getSIDL write setSIDL;
    property w : TBits_32 read getw write setw;
  end;
  TPORTG_CNEN = record
  private
    function  getCNEN0 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN1 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN10 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN11 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN12 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN13 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN14 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN15 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN16 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN17 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN18 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN2 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN3 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN4 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN5 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN6 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN7 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN8 : TBits_1; assembler; nostackframe; inline;
    function  getCNEN9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCNEN0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN16(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN17(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN18(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNEN9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCNEN0;
    procedure clearCNEN10;
    procedure clearCNEN11;
    procedure clearCNEN12;
    procedure clearCNEN13;
    procedure clearCNEN14;
    procedure clearCNEN15;
    procedure clearCNEN16;
    procedure clearCNEN17;
    procedure clearCNEN18;
    procedure clearCNEN1;
    procedure clearCNEN2;
    procedure clearCNEN3;
    procedure clearCNEN4;
    procedure clearCNEN5;
    procedure clearCNEN6;
    procedure clearCNEN7;
    procedure clearCNEN8;
    procedure clearCNEN9;
    procedure setCNEN0;
    procedure setCNEN10;
    procedure setCNEN11;
    procedure setCNEN12;
    procedure setCNEN13;
    procedure setCNEN14;
    procedure setCNEN15;
    procedure setCNEN16;
    procedure setCNEN17;
    procedure setCNEN18;
    procedure setCNEN1;
    procedure setCNEN2;
    procedure setCNEN3;
    procedure setCNEN4;
    procedure setCNEN5;
    procedure setCNEN6;
    procedure setCNEN7;
    procedure setCNEN8;
    procedure setCNEN9;
    property CNEN0 : TBits_1 read getCNEN0 write setCNEN0;
    property CNEN1 : TBits_1 read getCNEN1 write setCNEN1;
    property CNEN10 : TBits_1 read getCNEN10 write setCNEN10;
    property CNEN11 : TBits_1 read getCNEN11 write setCNEN11;
    property CNEN12 : TBits_1 read getCNEN12 write setCNEN12;
    property CNEN13 : TBits_1 read getCNEN13 write setCNEN13;
    property CNEN14 : TBits_1 read getCNEN14 write setCNEN14;
    property CNEN15 : TBits_1 read getCNEN15 write setCNEN15;
    property CNEN16 : TBits_1 read getCNEN16 write setCNEN16;
    property CNEN17 : TBits_1 read getCNEN17 write setCNEN17;
    property CNEN18 : TBits_1 read getCNEN18 write setCNEN18;
    property CNEN2 : TBits_1 read getCNEN2 write setCNEN2;
    property CNEN3 : TBits_1 read getCNEN3 write setCNEN3;
    property CNEN4 : TBits_1 read getCNEN4 write setCNEN4;
    property CNEN5 : TBits_1 read getCNEN5 write setCNEN5;
    property CNEN6 : TBits_1 read getCNEN6 write setCNEN6;
    property CNEN7 : TBits_1 read getCNEN7 write setCNEN7;
    property CNEN8 : TBits_1 read getCNEN8 write setCNEN8;
    property CNEN9 : TBits_1 read getCNEN9 write setCNEN9;
    property w : TBits_32 read getw write setw;
  end;
  TPORTG_CNPUE = record
  private
    function  getCNPUE0 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE1 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE10 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE11 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE12 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE13 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE14 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE15 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE16 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE17 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE18 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE2 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE3 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE4 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE5 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE6 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE7 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE8 : TBits_1; assembler; nostackframe; inline;
    function  getCNPUE9 : TBits_1; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setCNPUE0(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE1(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE10(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE11(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE12(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE13(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE14(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE15(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE16(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE17(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE18(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE2(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE3(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE4(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE5(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE6(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE7(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE8(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCNPUE9(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearCNPUE0;
    procedure clearCNPUE10;
    procedure clearCNPUE11;
    procedure clearCNPUE12;
    procedure clearCNPUE13;
    procedure clearCNPUE14;
    procedure clearCNPUE15;
    procedure clearCNPUE16;
    procedure clearCNPUE17;
    procedure clearCNPUE18;
    procedure clearCNPUE1;
    procedure clearCNPUE2;
    procedure clearCNPUE3;
    procedure clearCNPUE4;
    procedure clearCNPUE5;
    procedure clearCNPUE6;
    procedure clearCNPUE7;
    procedure clearCNPUE8;
    procedure clearCNPUE9;
    procedure setCNPUE0;
    procedure setCNPUE10;
    procedure setCNPUE11;
    procedure setCNPUE12;
    procedure setCNPUE13;
    procedure setCNPUE14;
    procedure setCNPUE15;
    procedure setCNPUE16;
    procedure setCNPUE17;
    procedure setCNPUE18;
    procedure setCNPUE1;
    procedure setCNPUE2;
    procedure setCNPUE3;
    procedure setCNPUE4;
    procedure setCNPUE5;
    procedure setCNPUE6;
    procedure setCNPUE7;
    procedure setCNPUE8;
    procedure setCNPUE9;
    property CNPUE0 : TBits_1 read getCNPUE0 write setCNPUE0;
    property CNPUE1 : TBits_1 read getCNPUE1 write setCNPUE1;
    property CNPUE10 : TBits_1 read getCNPUE10 write setCNPUE10;
    property CNPUE11 : TBits_1 read getCNPUE11 write setCNPUE11;
    property CNPUE12 : TBits_1 read getCNPUE12 write setCNPUE12;
    property CNPUE13 : TBits_1 read getCNPUE13 write setCNPUE13;
    property CNPUE14 : TBits_1 read getCNPUE14 write setCNPUE14;
    property CNPUE15 : TBits_1 read getCNPUE15 write setCNPUE15;
    property CNPUE16 : TBits_1 read getCNPUE16 write setCNPUE16;
    property CNPUE17 : TBits_1 read getCNPUE17 write setCNPUE17;
    property CNPUE18 : TBits_1 read getCNPUE18 write setCNPUE18;
    property CNPUE2 : TBits_1 read getCNPUE2 write setCNPUE2;
    property CNPUE3 : TBits_1 read getCNPUE3 write setCNPUE3;
    property CNPUE4 : TBits_1 read getCNPUE4 write setCNPUE4;
    property CNPUE5 : TBits_1 read getCNPUE5 write setCNPUE5;
    property CNPUE6 : TBits_1 read getCNPUE6 write setCNPUE6;
    property CNPUE7 : TBits_1 read getCNPUE7 write setCNPUE7;
    property CNPUE8 : TBits_1 read getCNPUE8 write setCNPUE8;
    property CNPUE9 : TBits_1 read getCNPUE9 write setCNPUE9;
    property w : TBits_32 read getw write setw;
  end;
type
  TPORTGRegisters = record
    TRISGbits : TPORTG_TRISG;
    TRISG : longWord;
    TRISGCLR : longWord;
    TRISGSET : longWord;
    TRISGINV : longWord;
    PORTGbits : TPORTG_PORTG;
    PORTG : longWord;
    PORTGCLR : longWord;
    PORTGSET : longWord;
    PORTGINV : longWord;
    LATGbits : TPORTG_LATG;
    LATG : longWord;
    LATGCLR : longWord;
    LATGSET : longWord;
    LATGINV : longWord;
    ODCGbits : TPORTG_ODCG;
    ODCG : longWord;
    ODCGCLR : longWord;
    ODCGSET : longWord;
    ODCGINV : longWord;
    CNCONbits : TPORTG_CNCON;
    CNCON : longWord;
    CNCONCLR : longWord;
    CNCONSET : longWord;
    CNCONINV : longWord;
    CNENbits : TPORTG_CNEN;
    CNEN : longWord;
    CNENCLR : longWord;
    CNENSET : longWord;
    CNENINV : longWord;
    CNPUEbits : TPORTG_CNPUE;
    CNPUE : longWord;
    CNPUECLR : longWord;
    CNPUESET : longWord;
    CNPUEINV : longWord;
  end;
  TDEVCFG_DEVCFG3 = record
  private
    function  getUSERID : TBits_16; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setUSERID(thebits : TBits_16); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    property USERID : TBits_16 read getUSERID write setUSERID;
    property w : TBits_32 read getw write setw;
  end;
  TDEVCFG_DEVCFG2 = record
  private
    function  getFPLLIDIV : TBits_3; assembler; nostackframe; inline;
    function  getFPLLMUL : TBits_3; assembler; nostackframe; inline;
    function  getFPLLODIV : TBits_3; assembler; nostackframe; inline;
    function  getUPLLEN : TBits_1; assembler; nostackframe; inline;
    function  getUPLLIDIV : TBits_3; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setFPLLIDIV(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setFPLLMUL(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setFPLLODIV(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setUPLLEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setUPLLIDIV(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearUPLLEN;
    procedure setUPLLEN;
    property FPLLIDIV : TBits_3 read getFPLLIDIV write setFPLLIDIV;
    property FPLLMUL : TBits_3 read getFPLLMUL write setFPLLMUL;
    property FPLLODIV : TBits_3 read getFPLLODIV write setFPLLODIV;
    property UPLLEN : TBits_1 read getUPLLEN write setUPLLEN;
    property UPLLIDIV : TBits_3 read getUPLLIDIV write setUPLLIDIV;
    property w : TBits_32 read getw write setw;
  end;
  TDEVCFG_DEVCFG1 = record
  private
    function  getFCKSM : TBits_2; assembler; nostackframe; inline;
    function  getFNOSC : TBits_3; assembler; nostackframe; inline;
    function  getFPBDIV : TBits_2; assembler; nostackframe; inline;
    function  getFSOSCEN : TBits_1; assembler; nostackframe; inline;
    function  getFWDTEN : TBits_1; assembler; nostackframe; inline;
    function  getIESO : TBits_1; assembler; nostackframe; inline;
    function  getOSCIOFNC : TBits_1; assembler; nostackframe; inline;
    function  getPOSCMOD : TBits_2; assembler; nostackframe; inline;
    function  getWDTPS : TBits_5; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setFCKSM(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setFNOSC(thebits : TBits_3); assembler; nostackframe; inline;
    procedure setFPBDIV(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setFSOSCEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setFWDTEN(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setIESO(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setOSCIOFNC(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPOSCMOD(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setWDTPS(thebits : TBits_5); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearFSOSCEN;
    procedure clearFWDTEN;
    procedure clearIESO;
    procedure clearOSCIOFNC;
    procedure setFSOSCEN;
    procedure setFWDTEN;
    procedure setIESO;
    procedure setOSCIOFNC;
    property FCKSM : TBits_2 read getFCKSM write setFCKSM;
    property FNOSC : TBits_3 read getFNOSC write setFNOSC;
    property FPBDIV : TBits_2 read getFPBDIV write setFPBDIV;
    property FSOSCEN : TBits_1 read getFSOSCEN write setFSOSCEN;
    property FWDTEN : TBits_1 read getFWDTEN write setFWDTEN;
    property IESO : TBits_1 read getIESO write setIESO;
    property OSCIOFNC : TBits_1 read getOSCIOFNC write setOSCIOFNC;
    property POSCMOD : TBits_2 read getPOSCMOD write setPOSCMOD;
    property WDTPS : TBits_5 read getWDTPS write setWDTPS;
    property w : TBits_32 read getw write setw;
  end;
  TDEVCFG_DEVCFG0 = record
  private
    function  getBWP : TBits_1; assembler; nostackframe; inline;
    function  getCP : TBits_1; assembler; nostackframe; inline;
    function  getDEBUG : TBits_2; assembler; nostackframe; inline;
    function  getFDEBUG : TBits_2; assembler; nostackframe; inline;
    function  getICESEL : TBits_1; assembler; nostackframe; inline;
    function  getPWP : TBits_8; assembler; nostackframe; inline;
    function  getw : TBits_32; assembler; nostackframe; inline;
    procedure setBWP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setCP(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setDEBUG(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setFDEBUG(thebits : TBits_2); assembler; nostackframe; inline;
    procedure setICESEL(thebits : TBits_1); assembler; nostackframe; inline;
    procedure setPWP(thebits : TBits_8); assembler; nostackframe; inline;
    procedure setw(thebits : TBits_32); assembler; nostackframe; inline;
  public
    procedure clearBWP;
    procedure clearCP;
    procedure clearICESEL;
    procedure setBWP;
    procedure setCP;
    procedure setICESEL;
    property BWP : TBits_1 read getBWP write setBWP;
    property CP : TBits_1 read getCP write setCP;
    property DEBUG : TBits_2 read getDEBUG write setDEBUG;
    property FDEBUG : TBits_2 read getFDEBUG write setFDEBUG;
    property ICESEL : TBits_1 read getICESEL write setICESEL;
    property PWP : TBits_8 read getPWP write setPWP;
    property w : TBits_32 read getw write setw;
  end;
const
  _CORE_TIMER_IRQ = 0;
  _CORE_SOFTWARE_0_IRQ = 1;
  _CORE_SOFTWARE_1_IRQ = 2;
  _EXTERNAL_0_IRQ = 3;
  _TIMER_1_IRQ = 4;
  _INPUT_CAPTURE_1_IRQ = 5;
  _OUTPUT_COMPARE_1_IRQ = 6;
  _EXTERNAL_1_IRQ = 7;
  _TIMER_2_IRQ = 8;
  _INPUT_CAPTURE_2_IRQ = 9;
  _OUTPUT_COMPARE_2_IRQ = 10;
  _EXTERNAL_2_IRQ = 11;
  _TIMER_3_IRQ = 12;
  _INPUT_CAPTURE_3_IRQ = 13;
  _OUTPUT_COMPARE_3_IRQ = 14;
  _EXTERNAL_3_IRQ = 15;
  _TIMER_4_IRQ = 16;
  _INPUT_CAPTURE_4_IRQ = 17;
  _OUTPUT_COMPARE_4_IRQ = 18;
  _EXTERNAL_4_IRQ = 19;
  _TIMER_5_IRQ = 20;
  _INPUT_CAPTURE_5_IRQ = 21;
  _OUTPUT_COMPARE_5_IRQ = 22;
  _UART1_ERR_IRQ = 26;
  _UART1_RX_IRQ = 27;
  _UART1_TX_IRQ = 28;
  _I2C1_BUS_IRQ = 29;
  _I2C1_SLAVE_IRQ = 30;
  _I2C1_MASTER_IRQ = 31;
  _CHANGE_NOTICE_IRQ = 32;
  _ADC_IRQ = 33;
  _PMP_IRQ = 34;
  _COMPARATOR_1_IRQ = 35;
  _COMPARATOR_2_IRQ = 36;
  _SPI2_ERR_IRQ = 37;
  _SPI2_TX_IRQ = 38;
  _SPI2_RX_IRQ = 39;
  _UART2_ERR_IRQ = 40;
  _UART2_RX_IRQ = 41;
  _UART2_TX_IRQ = 42;
  _I2C2_BUS_IRQ = 43;
  _I2C2_SLAVE_IRQ = 44;
  _I2C2_MASTER_IRQ = 45;
  _FAIL_SAFE_MONITOR_IRQ = 46;
  _RTCC_IRQ = 47;
  _DMA0_IRQ = 48;
  _DMA1_IRQ = 49;
  _DMA2_IRQ = 50;
  _DMA3_IRQ = 51;
  _FLASH_CONTROL_IRQ = 56;
  _USB_IRQ = 57;
const
  ADC10_BASE_ADDRESS = $BF809000;
var
  ADC10 : TADC10Registers absolute ADC10_BASE_ADDRESS;
const
  BMX_BASE_ADDRESS = $BF882000;
var
  BMX : TBMXRegisters absolute BMX_BASE_ADDRESS;
const
  CFG_BASE_ADDRESS = $BF80F200;
var
  CFG : TCFGRegisters absolute CFG_BASE_ADDRESS;
const
  CMP_BASE_ADDRESS = $BF80A000;
var
  CMP : TCMPRegisters absolute CMP_BASE_ADDRESS;
const
  CVR_BASE_ADDRESS = $BF809800;
var
  CVR : TCVRRegisters absolute CVR_BASE_ADDRESS;
const
  DMAC_BASE_ADDRESS = $BF883000;
var
  DMAC : TDMACRegisters absolute DMAC_BASE_ADDRESS;
const
  DMAC0_BASE_ADDRESS = $BF883060;
var
  DMAC0 : TDMAC0Registers absolute DMAC0_BASE_ADDRESS;
const
  DMAC1_BASE_ADDRESS = $BF883120;
var
  DMAC1 : TDMAC1Registers absolute DMAC1_BASE_ADDRESS;
const
  DMAC2_BASE_ADDRESS = $BF8831E0;
var
  DMAC2 : TDMAC2Registers absolute DMAC2_BASE_ADDRESS;
const
  DMAC3_BASE_ADDRESS = $BF8832A0;
var
  DMAC3 : TDMAC3Registers absolute DMAC3_BASE_ADDRESS;
const
  I2C1_BASE_ADDRESS = $BF805000;
var
  I2C1 : TI2C1Registers absolute I2C1_BASE_ADDRESS;
const
  I2C2_BASE_ADDRESS = $BF805200;
var
  I2C2 : TI2C2Registers absolute I2C2_BASE_ADDRESS;
const
  ICAP1_BASE_ADDRESS = $BF802000;
var
  ICAP1 : TICAP1Registers absolute ICAP1_BASE_ADDRESS;
const
  ICAP2_BASE_ADDRESS = $BF802200;
var
  ICAP2 : TICAP2Registers absolute ICAP2_BASE_ADDRESS;
const
  ICAP3_BASE_ADDRESS = $BF802400;
var
  ICAP3 : TICAP3Registers absolute ICAP3_BASE_ADDRESS;
const
  ICAP4_BASE_ADDRESS = $BF802600;
var
  ICAP4 : TICAP4Registers absolute ICAP4_BASE_ADDRESS;
const
  ICAP5_BASE_ADDRESS = $BF802800;
var
  ICAP5 : TICAP5Registers absolute ICAP5_BASE_ADDRESS;
const
  INT_BASE_ADDRESS = $BF881000;
var
  INT : TINTRegisters absolute INT_BASE_ADDRESS;
const
  NVM_BASE_ADDRESS = $BF80F400;
var
  NVM : TNVMRegisters absolute NVM_BASE_ADDRESS;
const
  OCMP1_BASE_ADDRESS = $BF803000;
var
  OCMP1 : TOCMP1Registers absolute OCMP1_BASE_ADDRESS;
const
  OCMP2_BASE_ADDRESS = $BF803200;
var
  OCMP2 : TOCMP2Registers absolute OCMP2_BASE_ADDRESS;
const
  OCMP3_BASE_ADDRESS = $BF803400;
var
  OCMP3 : TOCMP3Registers absolute OCMP3_BASE_ADDRESS;
const
  OCMP4_BASE_ADDRESS = $BF803600;
var
  OCMP4 : TOCMP4Registers absolute OCMP4_BASE_ADDRESS;
const
  OCMP5_BASE_ADDRESS = $BF803800;
var
  OCMP5 : TOCMP5Registers absolute OCMP5_BASE_ADDRESS;
const
  OSC_BASE_ADDRESS = $BF80F000;
var
  OSC : TOSCRegisters absolute OSC_BASE_ADDRESS;
const
  PCACHE_BASE_ADDRESS = $BF884000;
var
  PCACHE : TPCACHERegisters absolute PCACHE_BASE_ADDRESS;
const
  PMP_BASE_ADDRESS = $BF807000;
var
  PMP : TPMPRegisters absolute PMP_BASE_ADDRESS;
const
  PORTB_BASE_ADDRESS = $BF886040;
var
  PORTB : TPORTBRegisters absolute PORTB_BASE_ADDRESS;
const
  PORTC_BASE_ADDRESS = $BF886080;
var
  PORTC : TPORTCRegisters absolute PORTC_BASE_ADDRESS;
const
  PORTD_BASE_ADDRESS = $BF8860C0;
var
  PORTD : TPORTDRegisters absolute PORTD_BASE_ADDRESS;
const
  PORTE_BASE_ADDRESS = $BF886100;
var
  PORTE : TPORTERegisters absolute PORTE_BASE_ADDRESS;
const
  PORTF_BASE_ADDRESS = $BF886140;
var
  PORTF : TPORTFRegisters absolute PORTF_BASE_ADDRESS;
const
  PORTG_BASE_ADDRESS = $BF886180;
var
  PORTG : TPORTGRegisters absolute PORTG_BASE_ADDRESS;
const
  RCON_BASE_ADDRESS = $BF80F600;
var
  RCON : TRCONRegisters absolute RCON_BASE_ADDRESS;
const
  RTCC_BASE_ADDRESS = $BF800200;
var
  RTCC : TRTCCRegisters absolute RTCC_BASE_ADDRESS;
const
  SPI2_BASE_ADDRESS = $BF805A00;
var
  SPI2 : TSPI2Registers absolute SPI2_BASE_ADDRESS;
const
  TMR1_BASE_ADDRESS = $BF800600;
var
  TMR1 : TTMR1Registers absolute TMR1_BASE_ADDRESS;
const
  TMR23_BASE_ADDRESS = $BF800800;
var
  TMR23 : TTMR23Registers absolute TMR23_BASE_ADDRESS;
const
  TMR3_BASE_ADDRESS = $BF800A00;
var
  TMR3 : TTMR3Registers absolute TMR3_BASE_ADDRESS;
const
  TMR4_BASE_ADDRESS = $BF800C00;
var
  TMR4 : TTMR4Registers absolute TMR4_BASE_ADDRESS;
const
  TMR5_BASE_ADDRESS = $BF800E00;
var
  TMR5 : TTMR5Registers absolute TMR5_BASE_ADDRESS;
const
  UART1_BASE_ADDRESS = $BF806000;
var
  UART1 : TUART1Registers absolute UART1_BASE_ADDRESS;
const
  UART2_BASE_ADDRESS = $BF806200;
var
  UART2 : TUART2Registers absolute UART2_BASE_ADDRESS;
const
  USB_BASE_ADDRESS = $BF885040;
var
  USB : TUSBRegisters absolute USB_BASE_ADDRESS;
const
  WDT_BASE_ADDRESS = $BF800000;
var
  WDT : TWDTRegisters absolute WDT_BASE_ADDRESS;
const
  _APPI_BASE_ADDRESS = $BF880190;
var
  _APPI : T_APPIRegisters absolute _APPI_BASE_ADDRESS;
const
  _APPO_BASE_ADDRESS = $BF880180;
var
  _APPO : T_APPORegisters absolute _APPO_BASE_ADDRESS;
const
  _DDPSTAT_BASE_ADDRESS = $BF880140;
var
  _DDPSTAT : T_DDPSTATRegisters absolute _DDPSTAT_BASE_ADDRESS;
const
  _STRO_BASE_ADDRESS = $BF880170;
var
  _STRO : T_STRORegisters absolute _STRO_BASE_ADDRESS;
implementation
procedure TWDT_WDTCON.setWDTCLR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TWDT_WDTCON.clearWDTCLR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TWDT_WDTCON.setWDTCLR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TWDT_WDTCON.getWDTCLR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TWDT_WDTCON.setSWDTPS(thebits : TBits_5); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,5
  sw      $v1,($a0)
end;
function  TWDT_WDTCON.getSWDTPS : TBits_5;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,5
end;
procedure TWDT_WDTCON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TWDT_WDTCON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TWDT_WDTCON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TWDT_WDTCON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TWDT_WDTCON.setSWDTPS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TWDT_WDTCON.clearSWDTPS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TWDT_WDTCON.setSWDTPS0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TWDT_WDTCON.getSWDTPS0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TWDT_WDTCON.setSWDTPS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TWDT_WDTCON.clearSWDTPS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TWDT_WDTCON.setSWDTPS1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TWDT_WDTCON.getSWDTPS1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TWDT_WDTCON.setSWDTPS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TWDT_WDTCON.clearSWDTPS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TWDT_WDTCON.setSWDTPS2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TWDT_WDTCON.getSWDTPS2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TWDT_WDTCON.setSWDTPS3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TWDT_WDTCON.clearSWDTPS3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TWDT_WDTCON.setSWDTPS3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TWDT_WDTCON.getSWDTPS3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TWDT_WDTCON.setSWDTPS4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TWDT_WDTCON.clearSWDTPS4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TWDT_WDTCON.setSWDTPS4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TWDT_WDTCON.getSWDTPS4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TWDT_WDTCON.setWDTPSTA(thebits : TBits_5); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,5
  sw      $v1,($a0)
end;
function  TWDT_WDTCON.getWDTPSTA : TBits_5;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,5
end;
procedure TWDT_WDTCON.setWDTPS(thebits : TBits_5); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,5
  sw      $v1,($a0)
end;
function  TWDT_WDTCON.getWDTPS : TBits_5;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,5
end;
procedure TWDT_WDTCON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TWDT_WDTCON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TRTCC_RTCCON.setRTCOE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TRTCC_RTCCON.clearRTCOE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TRTCC_RTCCON.setRTCOE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TRTCC_RTCCON.getRTCOE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TRTCC_RTCCON.setHALFSEC; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TRTCC_RTCCON.clearHALFSEC; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TRTCC_RTCCON.setHALFSEC(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TRTCC_RTCCON.getHALFSEC : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TRTCC_RTCCON.setRTCSYNC; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TRTCC_RTCCON.clearRTCSYNC; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TRTCC_RTCCON.setRTCSYNC(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TRTCC_RTCCON.getRTCSYNC : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TRTCC_RTCCON.setRTCWREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TRTCC_RTCCON.clearRTCWREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TRTCC_RTCCON.setRTCWREN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TRTCC_RTCCON.getRTCWREN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TRTCC_RTCCON.setRTCCLKON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TRTCC_RTCCON.clearRTCCLKON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TRTCC_RTCCON.setRTCCLKON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TRTCC_RTCCON.getRTCCLKON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TRTCC_RTCCON.setRTSECSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TRTCC_RTCCON.clearRTSECSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TRTCC_RTCCON.setRTSECSEL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TRTCC_RTCCON.getRTSECSEL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TRTCC_RTCCON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TRTCC_RTCCON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TRTCC_RTCCON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TRTCC_RTCCON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TRTCC_RTCCON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TRTCC_RTCCON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TRTCC_RTCCON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TRTCC_RTCCON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TRTCC_RTCCON.setCAL(thebits : TBits_10); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,16
  lui    $v0,64512
  ori    $v0,$v0,65535
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TRTCC_RTCCON.getCAL : TBits_10;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,16
  lui    $v0,1023
  and    $a1,$a1,$v0
end;
procedure TRTCC_RTCCON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TRTCC_RTCCON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TRTCC_RTCALRM.setARPT(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,0
  lui    $v0,65535
  ori    $v0,$v0,65280
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TRTCC_RTCALRM.getARPT : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,0
  ori    $v0,$zero,255
  and    $a1,$a1,$v0
end;
procedure TRTCC_RTCALRM.setAMASK(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCALRM.getAMASK : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,4
end;
procedure TRTCC_RTCALRM.setALRMSYNC; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TRTCC_RTCALRM.clearALRMSYNC; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TRTCC_RTCALRM.setALRMSYNC(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TRTCC_RTCALRM.getALRMSYNC : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TRTCC_RTCALRM.setPIV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TRTCC_RTCALRM.clearPIV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TRTCC_RTCALRM.setPIV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TRTCC_RTCALRM.getPIV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TRTCC_RTCALRM.setCHIME; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TRTCC_RTCALRM.clearCHIME; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TRTCC_RTCALRM.setCHIME(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TRTCC_RTCALRM.getCHIME : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TRTCC_RTCALRM.setALRMEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TRTCC_RTCALRM.clearALRMEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TRTCC_RTCALRM.setALRMEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TRTCC_RTCALRM.getALRMEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TRTCC_RTCALRM.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TRTCC_RTCALRM.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TRTCC_RTCTIME.setSEC01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCTIME.getSEC01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,4
end;
procedure TRTCC_RTCTIME.setSEC10(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCTIME.getSEC10 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,4
end;
procedure TRTCC_RTCTIME.setMIN01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCTIME.getMIN01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,4
end;
procedure TRTCC_RTCTIME.setMIN10(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,20,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCTIME.getMIN10 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,20,4
end;
procedure TRTCC_RTCTIME.setHR01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,24,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCTIME.getHR01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,24,4
end;
procedure TRTCC_RTCTIME.setHR10(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,28,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCTIME.getHR10 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,28,4
end;
procedure TRTCC_RTCTIME.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TRTCC_RTCTIME.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TRTCC_RTCDATE.setWDAY01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCDATE.getWDAY01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,4
end;
procedure TRTCC_RTCDATE.setDAY01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCDATE.getDAY01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,4
end;
procedure TRTCC_RTCDATE.setDAY10(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCDATE.getDAY10 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,4
end;
procedure TRTCC_RTCDATE.setMONTH01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCDATE.getMONTH01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,4
end;
procedure TRTCC_RTCDATE.setMONTH10(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,20,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCDATE.getMONTH10 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,20,4
end;
procedure TRTCC_RTCDATE.setYEAR01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,24,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCDATE.getYEAR01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,24,4
end;
procedure TRTCC_RTCDATE.setYEAR10(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,28,4
  sw      $v1,($a0)
end;
function  TRTCC_RTCDATE.getYEAR10 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,28,4
end;
procedure TRTCC_RTCDATE.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TRTCC_RTCDATE.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TRTCC_ALRMTIME.setSEC01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,4
  sw      $v1,($a0)
end;
function  TRTCC_ALRMTIME.getSEC01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,4
end;
procedure TRTCC_ALRMTIME.setSEC10(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,4
  sw      $v1,($a0)
end;
function  TRTCC_ALRMTIME.getSEC10 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,4
end;
procedure TRTCC_ALRMTIME.setMIN01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,4
  sw      $v1,($a0)
end;
function  TRTCC_ALRMTIME.getMIN01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,4
end;
procedure TRTCC_ALRMTIME.setMIN10(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,20,4
  sw      $v1,($a0)
end;
function  TRTCC_ALRMTIME.getMIN10 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,20,4
end;
procedure TRTCC_ALRMTIME.setHR01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,24,4
  sw      $v1,($a0)
end;
function  TRTCC_ALRMTIME.getHR01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,24,4
end;
procedure TRTCC_ALRMTIME.setHR10(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,28,4
  sw      $v1,($a0)
end;
function  TRTCC_ALRMTIME.getHR10 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,28,4
end;
procedure TRTCC_ALRMTIME.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TRTCC_ALRMTIME.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TRTCC_ALRMDATE.setWDAY01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,4
  sw      $v1,($a0)
end;
function  TRTCC_ALRMDATE.getWDAY01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,4
end;
procedure TRTCC_ALRMDATE.setDAY01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,4
  sw      $v1,($a0)
end;
function  TRTCC_ALRMDATE.getDAY01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,4
end;
procedure TRTCC_ALRMDATE.setDAY10(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,4
  sw      $v1,($a0)
end;
function  TRTCC_ALRMDATE.getDAY10 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,4
end;
procedure TRTCC_ALRMDATE.setMONTH01(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,4
  sw      $v1,($a0)
end;
function  TRTCC_ALRMDATE.getMONTH01 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,4
end;
procedure TRTCC_ALRMDATE.setMONTH10(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,20,4
  sw      $v1,($a0)
end;
function  TRTCC_ALRMDATE.getMONTH10 : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,20,4
end;
procedure TRTCC_ALRMDATE.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TRTCC_ALRMDATE.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TTMR1_T1CON.setTCS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TTMR1_T1CON.clearTCS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TTMR1_T1CON.setTCS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TTMR1_T1CON.getTCS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TTMR1_T1CON.setTSYNC; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TTMR1_T1CON.clearTSYNC; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TTMR1_T1CON.setTSYNC(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TTMR1_T1CON.getTSYNC : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TTMR1_T1CON.setTCKPS(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,2
  sw      $v1,($a0)
end;
function  TTMR1_T1CON.getTCKPS : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,2
end;
procedure TTMR1_T1CON.setTGATE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TTMR1_T1CON.clearTGATE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TTMR1_T1CON.setTGATE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TTMR1_T1CON.getTGATE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TTMR1_T1CON.setTWIP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TTMR1_T1CON.clearTWIP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TTMR1_T1CON.setTWIP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TTMR1_T1CON.getTWIP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TTMR1_T1CON.setTWDIS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TTMR1_T1CON.clearTWDIS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TTMR1_T1CON.setTWDIS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TTMR1_T1CON.getTWDIS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TTMR1_T1CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TTMR1_T1CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TTMR1_T1CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TTMR1_T1CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TTMR1_T1CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TTMR1_T1CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TTMR1_T1CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TTMR1_T1CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TTMR1_T1CON.setTCKPS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TTMR1_T1CON.clearTCKPS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TTMR1_T1CON.setTCKPS0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TTMR1_T1CON.getTCKPS0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TTMR1_T1CON.setTCKPS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TTMR1_T1CON.clearTCKPS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TTMR1_T1CON.setTCKPS1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TTMR1_T1CON.getTCKPS1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TTMR1_T1CON.setTSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TTMR1_T1CON.clearTSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TTMR1_T1CON.setTSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TTMR1_T1CON.getTSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TTMR1_T1CON.setTON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TTMR1_T1CON.clearTON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TTMR1_T1CON.setTON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TTMR1_T1CON.getTON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TTMR1_T1CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TTMR1_T1CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TTMR23_T2CON.setTCS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TTMR23_T2CON.clearTCS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TTMR23_T2CON.setTCS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TTMR23_T2CON.getTCS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TTMR23_T2CON.setT32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TTMR23_T2CON.clearT32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TTMR23_T2CON.setT32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TTMR23_T2CON.getT32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TTMR23_T2CON.setTCKPS(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,3
  sw      $v1,($a0)
end;
function  TTMR23_T2CON.getTCKPS : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,3
end;
procedure TTMR23_T2CON.setTGATE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TTMR23_T2CON.clearTGATE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TTMR23_T2CON.setTGATE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TTMR23_T2CON.getTGATE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TTMR23_T2CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TTMR23_T2CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TTMR23_T2CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TTMR23_T2CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TTMR23_T2CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TTMR23_T2CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TTMR23_T2CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TTMR23_T2CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TTMR23_T2CON.setTCKPS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TTMR23_T2CON.clearTCKPS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TTMR23_T2CON.setTCKPS0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TTMR23_T2CON.getTCKPS0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TTMR23_T2CON.setTCKPS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TTMR23_T2CON.clearTCKPS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TTMR23_T2CON.setTCKPS1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TTMR23_T2CON.getTCKPS1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TTMR23_T2CON.setTCKPS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TTMR23_T2CON.clearTCKPS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TTMR23_T2CON.setTCKPS2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TTMR23_T2CON.getTCKPS2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TTMR23_T2CON.setTSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TTMR23_T2CON.clearTSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TTMR23_T2CON.setTSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TTMR23_T2CON.getTSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TTMR23_T2CON.setTON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TTMR23_T2CON.clearTON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TTMR23_T2CON.setTON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TTMR23_T2CON.getTON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TTMR23_T2CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TTMR23_T2CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TTMR3_T3CON.setTCS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TTMR3_T3CON.clearTCS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TTMR3_T3CON.setTCS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TTMR3_T3CON.getTCS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TTMR3_T3CON.setTCKPS(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,3
  sw      $v1,($a0)
end;
function  TTMR3_T3CON.getTCKPS : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,3
end;
procedure TTMR3_T3CON.setTGATE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TTMR3_T3CON.clearTGATE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TTMR3_T3CON.setTGATE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TTMR3_T3CON.getTGATE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TTMR3_T3CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TTMR3_T3CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TTMR3_T3CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TTMR3_T3CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TTMR3_T3CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TTMR3_T3CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TTMR3_T3CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TTMR3_T3CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TTMR3_T3CON.setTCKPS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TTMR3_T3CON.clearTCKPS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TTMR3_T3CON.setTCKPS0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TTMR3_T3CON.getTCKPS0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TTMR3_T3CON.setTCKPS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TTMR3_T3CON.clearTCKPS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TTMR3_T3CON.setTCKPS1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TTMR3_T3CON.getTCKPS1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TTMR3_T3CON.setTCKPS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TTMR3_T3CON.clearTCKPS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TTMR3_T3CON.setTCKPS2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TTMR3_T3CON.getTCKPS2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TTMR3_T3CON.setTSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TTMR3_T3CON.clearTSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TTMR3_T3CON.setTSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TTMR3_T3CON.getTSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TTMR3_T3CON.setTON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TTMR3_T3CON.clearTON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TTMR3_T3CON.setTON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TTMR3_T3CON.getTON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TTMR3_T3CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TTMR3_T3CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TTMR4_T4CON.setTCS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TTMR4_T4CON.clearTCS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TTMR4_T4CON.setTCS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TTMR4_T4CON.getTCS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TTMR4_T4CON.setT32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TTMR4_T4CON.clearT32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TTMR4_T4CON.setT32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TTMR4_T4CON.getT32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TTMR4_T4CON.setTCKPS(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,3
  sw      $v1,($a0)
end;
function  TTMR4_T4CON.getTCKPS : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,3
end;
procedure TTMR4_T4CON.setTGATE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TTMR4_T4CON.clearTGATE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TTMR4_T4CON.setTGATE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TTMR4_T4CON.getTGATE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TTMR4_T4CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TTMR4_T4CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TTMR4_T4CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TTMR4_T4CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TTMR4_T4CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TTMR4_T4CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TTMR4_T4CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TTMR4_T4CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TTMR4_T4CON.setTCKPS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TTMR4_T4CON.clearTCKPS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TTMR4_T4CON.setTCKPS0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TTMR4_T4CON.getTCKPS0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TTMR4_T4CON.setTCKPS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TTMR4_T4CON.clearTCKPS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TTMR4_T4CON.setTCKPS1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TTMR4_T4CON.getTCKPS1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TTMR4_T4CON.setTCKPS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TTMR4_T4CON.clearTCKPS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TTMR4_T4CON.setTCKPS2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TTMR4_T4CON.getTCKPS2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TTMR4_T4CON.setTSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TTMR4_T4CON.clearTSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TTMR4_T4CON.setTSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TTMR4_T4CON.getTSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TTMR4_T4CON.setTON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TTMR4_T4CON.clearTON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TTMR4_T4CON.setTON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TTMR4_T4CON.getTON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TTMR4_T4CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TTMR4_T4CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TTMR5_T5CON.setTCS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TTMR5_T5CON.clearTCS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TTMR5_T5CON.setTCS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TTMR5_T5CON.getTCS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TTMR5_T5CON.setTCKPS(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,3
  sw      $v1,($a0)
end;
function  TTMR5_T5CON.getTCKPS : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,3
end;
procedure TTMR5_T5CON.setTGATE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TTMR5_T5CON.clearTGATE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TTMR5_T5CON.setTGATE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TTMR5_T5CON.getTGATE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TTMR5_T5CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TTMR5_T5CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TTMR5_T5CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TTMR5_T5CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TTMR5_T5CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TTMR5_T5CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TTMR5_T5CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TTMR5_T5CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TTMR5_T5CON.setTCKPS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TTMR5_T5CON.clearTCKPS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TTMR5_T5CON.setTCKPS0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TTMR5_T5CON.getTCKPS0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TTMR5_T5CON.setTCKPS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TTMR5_T5CON.clearTCKPS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TTMR5_T5CON.setTCKPS1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TTMR5_T5CON.getTCKPS1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TTMR5_T5CON.setTCKPS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TTMR5_T5CON.clearTCKPS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TTMR5_T5CON.setTCKPS2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TTMR5_T5CON.getTCKPS2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TTMR5_T5CON.setTSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TTMR5_T5CON.clearTSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TTMR5_T5CON.setTSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TTMR5_T5CON.getTSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TTMR5_T5CON.setTON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TTMR5_T5CON.clearTON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TTMR5_T5CON.setTON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TTMR5_T5CON.getTON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TTMR5_T5CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TTMR5_T5CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TICAP1_IC1CON.setICM(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getICM : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TICAP1_IC1CON.setICBNE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearICBNE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setICBNE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getICBNE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TICAP1_IC1CON.setICOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearICOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setICOV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getICOV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TICAP1_IC1CON.setICI(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,2
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getICI : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,2
end;
procedure TICAP1_IC1CON.setICTMR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearICTMR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setICTMR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getICTMR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TICAP1_IC1CON.setC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setC32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getC32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TICAP1_IC1CON.setFEDGE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearFEDGE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setFEDGE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getFEDGE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TICAP1_IC1CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TICAP1_IC1CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TICAP1_IC1CON.setICM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearICM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setICM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getICM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TICAP1_IC1CON.setICM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearICM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setICM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getICM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TICAP1_IC1CON.setICM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearICM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setICM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getICM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TICAP1_IC1CON.setICI0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearICI0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setICI0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getICI0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TICAP1_IC1CON.setICI1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearICI1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setICI1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getICI1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TICAP1_IC1CON.setICSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TICAP1_IC1CON.clearICSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TICAP1_IC1CON.setICSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TICAP1_IC1CON.getICSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TICAP1_IC1CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TICAP1_IC1CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TICAP2_IC2CON.setICM(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getICM : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TICAP2_IC2CON.setICBNE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearICBNE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setICBNE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getICBNE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TICAP2_IC2CON.setICOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearICOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setICOV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getICOV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TICAP2_IC2CON.setICI(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,2
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getICI : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,2
end;
procedure TICAP2_IC2CON.setICTMR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearICTMR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setICTMR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getICTMR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TICAP2_IC2CON.setC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setC32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getC32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TICAP2_IC2CON.setFEDGE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearFEDGE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setFEDGE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getFEDGE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TICAP2_IC2CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TICAP2_IC2CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TICAP2_IC2CON.setICM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearICM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setICM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getICM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TICAP2_IC2CON.setICM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearICM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setICM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getICM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TICAP2_IC2CON.setICM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearICM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setICM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getICM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TICAP2_IC2CON.setICI0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearICI0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setICI0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getICI0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TICAP2_IC2CON.setICI1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearICI1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setICI1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getICI1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TICAP2_IC2CON.setICSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TICAP2_IC2CON.clearICSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TICAP2_IC2CON.setICSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TICAP2_IC2CON.getICSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TICAP2_IC2CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TICAP2_IC2CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TICAP3_IC3CON.setICM(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getICM : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TICAP3_IC3CON.setICBNE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearICBNE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setICBNE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getICBNE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TICAP3_IC3CON.setICOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearICOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setICOV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getICOV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TICAP3_IC3CON.setICI(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,2
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getICI : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,2
end;
procedure TICAP3_IC3CON.setICTMR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearICTMR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setICTMR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getICTMR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TICAP3_IC3CON.setC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setC32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getC32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TICAP3_IC3CON.setFEDGE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearFEDGE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setFEDGE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getFEDGE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TICAP3_IC3CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TICAP3_IC3CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TICAP3_IC3CON.setICM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearICM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setICM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getICM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TICAP3_IC3CON.setICM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearICM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setICM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getICM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TICAP3_IC3CON.setICM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearICM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setICM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getICM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TICAP3_IC3CON.setICI0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearICI0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setICI0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getICI0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TICAP3_IC3CON.setICI1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearICI1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setICI1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getICI1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TICAP3_IC3CON.setICSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TICAP3_IC3CON.clearICSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TICAP3_IC3CON.setICSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TICAP3_IC3CON.getICSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TICAP3_IC3CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TICAP3_IC3CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TICAP4_IC4CON.setICM(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getICM : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TICAP4_IC4CON.setICBNE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearICBNE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setICBNE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getICBNE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TICAP4_IC4CON.setICOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearICOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setICOV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getICOV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TICAP4_IC4CON.setICI(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,2
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getICI : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,2
end;
procedure TICAP4_IC4CON.setICTMR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearICTMR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setICTMR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getICTMR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TICAP4_IC4CON.setC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setC32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getC32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TICAP4_IC4CON.setFEDGE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearFEDGE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setFEDGE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getFEDGE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TICAP4_IC4CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TICAP4_IC4CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TICAP4_IC4CON.setICM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearICM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setICM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getICM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TICAP4_IC4CON.setICM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearICM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setICM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getICM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TICAP4_IC4CON.setICM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearICM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setICM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getICM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TICAP4_IC4CON.setICI0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearICI0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setICI0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getICI0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TICAP4_IC4CON.setICI1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearICI1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setICI1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getICI1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TICAP4_IC4CON.setICSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TICAP4_IC4CON.clearICSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TICAP4_IC4CON.setICSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TICAP4_IC4CON.getICSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TICAP4_IC4CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TICAP4_IC4CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TICAP5_IC5CON.setICM(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getICM : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TICAP5_IC5CON.setICBNE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearICBNE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setICBNE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getICBNE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TICAP5_IC5CON.setICOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearICOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setICOV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getICOV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TICAP5_IC5CON.setICI(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,2
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getICI : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,2
end;
procedure TICAP5_IC5CON.setICTMR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearICTMR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setICTMR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getICTMR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TICAP5_IC5CON.setC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setC32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getC32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TICAP5_IC5CON.setFEDGE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearFEDGE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setFEDGE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getFEDGE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TICAP5_IC5CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TICAP5_IC5CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TICAP5_IC5CON.setICM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearICM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setICM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getICM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TICAP5_IC5CON.setICM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearICM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setICM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getICM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TICAP5_IC5CON.setICM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearICM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setICM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getICM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TICAP5_IC5CON.setICI0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearICI0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setICI0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getICI0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TICAP5_IC5CON.setICI1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearICI1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setICI1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getICI1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TICAP5_IC5CON.setICSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TICAP5_IC5CON.clearICSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TICAP5_IC5CON.setICSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TICAP5_IC5CON.getICSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TICAP5_IC5CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TICAP5_IC5CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TOCMP1_OC1CON.setOCM(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TOCMP1_OC1CON.getOCM : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TOCMP1_OC1CON.setOCTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TOCMP1_OC1CON.clearOCTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TOCMP1_OC1CON.setOCTSEL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TOCMP1_OC1CON.getOCTSEL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TOCMP1_OC1CON.setOCFLT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TOCMP1_OC1CON.clearOCFLT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TOCMP1_OC1CON.setOCFLT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TOCMP1_OC1CON.getOCFLT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TOCMP1_OC1CON.setOC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TOCMP1_OC1CON.clearOC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TOCMP1_OC1CON.setOC32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TOCMP1_OC1CON.getOC32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TOCMP1_OC1CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TOCMP1_OC1CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TOCMP1_OC1CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TOCMP1_OC1CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TOCMP1_OC1CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TOCMP1_OC1CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TOCMP1_OC1CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TOCMP1_OC1CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TOCMP1_OC1CON.setOCM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TOCMP1_OC1CON.clearOCM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TOCMP1_OC1CON.setOCM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TOCMP1_OC1CON.getOCM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TOCMP1_OC1CON.setOCM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TOCMP1_OC1CON.clearOCM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TOCMP1_OC1CON.setOCM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TOCMP1_OC1CON.getOCM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TOCMP1_OC1CON.setOCM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TOCMP1_OC1CON.clearOCM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TOCMP1_OC1CON.setOCM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TOCMP1_OC1CON.getOCM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TOCMP1_OC1CON.setOCSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TOCMP1_OC1CON.clearOCSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TOCMP1_OC1CON.setOCSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TOCMP1_OC1CON.getOCSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TOCMP1_OC1CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TOCMP1_OC1CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TOCMP2_OC2CON.setOCM(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TOCMP2_OC2CON.getOCM : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TOCMP2_OC2CON.setOCTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TOCMP2_OC2CON.clearOCTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TOCMP2_OC2CON.setOCTSEL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TOCMP2_OC2CON.getOCTSEL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TOCMP2_OC2CON.setOCFLT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TOCMP2_OC2CON.clearOCFLT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TOCMP2_OC2CON.setOCFLT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TOCMP2_OC2CON.getOCFLT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TOCMP2_OC2CON.setOC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TOCMP2_OC2CON.clearOC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TOCMP2_OC2CON.setOC32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TOCMP2_OC2CON.getOC32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TOCMP2_OC2CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TOCMP2_OC2CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TOCMP2_OC2CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TOCMP2_OC2CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TOCMP2_OC2CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TOCMP2_OC2CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TOCMP2_OC2CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TOCMP2_OC2CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TOCMP2_OC2CON.setOCM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TOCMP2_OC2CON.clearOCM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TOCMP2_OC2CON.setOCM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TOCMP2_OC2CON.getOCM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TOCMP2_OC2CON.setOCM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TOCMP2_OC2CON.clearOCM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TOCMP2_OC2CON.setOCM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TOCMP2_OC2CON.getOCM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TOCMP2_OC2CON.setOCM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TOCMP2_OC2CON.clearOCM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TOCMP2_OC2CON.setOCM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TOCMP2_OC2CON.getOCM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TOCMP2_OC2CON.setOCSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TOCMP2_OC2CON.clearOCSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TOCMP2_OC2CON.setOCSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TOCMP2_OC2CON.getOCSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TOCMP2_OC2CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TOCMP2_OC2CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TOCMP3_OC3CON.setOCM(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TOCMP3_OC3CON.getOCM : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TOCMP3_OC3CON.setOCTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TOCMP3_OC3CON.clearOCTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TOCMP3_OC3CON.setOCTSEL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TOCMP3_OC3CON.getOCTSEL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TOCMP3_OC3CON.setOCFLT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TOCMP3_OC3CON.clearOCFLT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TOCMP3_OC3CON.setOCFLT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TOCMP3_OC3CON.getOCFLT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TOCMP3_OC3CON.setOC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TOCMP3_OC3CON.clearOC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TOCMP3_OC3CON.setOC32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TOCMP3_OC3CON.getOC32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TOCMP3_OC3CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TOCMP3_OC3CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TOCMP3_OC3CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TOCMP3_OC3CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TOCMP3_OC3CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TOCMP3_OC3CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TOCMP3_OC3CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TOCMP3_OC3CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TOCMP3_OC3CON.setOCM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TOCMP3_OC3CON.clearOCM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TOCMP3_OC3CON.setOCM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TOCMP3_OC3CON.getOCM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TOCMP3_OC3CON.setOCM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TOCMP3_OC3CON.clearOCM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TOCMP3_OC3CON.setOCM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TOCMP3_OC3CON.getOCM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TOCMP3_OC3CON.setOCM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TOCMP3_OC3CON.clearOCM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TOCMP3_OC3CON.setOCM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TOCMP3_OC3CON.getOCM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TOCMP3_OC3CON.setOCSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TOCMP3_OC3CON.clearOCSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TOCMP3_OC3CON.setOCSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TOCMP3_OC3CON.getOCSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TOCMP3_OC3CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TOCMP3_OC3CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TOCMP4_OC4CON.setOCM(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TOCMP4_OC4CON.getOCM : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TOCMP4_OC4CON.setOCTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TOCMP4_OC4CON.clearOCTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TOCMP4_OC4CON.setOCTSEL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TOCMP4_OC4CON.getOCTSEL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TOCMP4_OC4CON.setOCFLT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TOCMP4_OC4CON.clearOCFLT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TOCMP4_OC4CON.setOCFLT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TOCMP4_OC4CON.getOCFLT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TOCMP4_OC4CON.setOC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TOCMP4_OC4CON.clearOC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TOCMP4_OC4CON.setOC32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TOCMP4_OC4CON.getOC32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TOCMP4_OC4CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TOCMP4_OC4CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TOCMP4_OC4CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TOCMP4_OC4CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TOCMP4_OC4CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TOCMP4_OC4CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TOCMP4_OC4CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TOCMP4_OC4CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TOCMP4_OC4CON.setOCM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TOCMP4_OC4CON.clearOCM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TOCMP4_OC4CON.setOCM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TOCMP4_OC4CON.getOCM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TOCMP4_OC4CON.setOCM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TOCMP4_OC4CON.clearOCM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TOCMP4_OC4CON.setOCM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TOCMP4_OC4CON.getOCM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TOCMP4_OC4CON.setOCM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TOCMP4_OC4CON.clearOCM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TOCMP4_OC4CON.setOCM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TOCMP4_OC4CON.getOCM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TOCMP4_OC4CON.setOCSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TOCMP4_OC4CON.clearOCSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TOCMP4_OC4CON.setOCSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TOCMP4_OC4CON.getOCSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TOCMP4_OC4CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TOCMP4_OC4CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TOCMP5_OC5CON.setOCM(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TOCMP5_OC5CON.getOCM : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TOCMP5_OC5CON.setOCTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TOCMP5_OC5CON.clearOCTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TOCMP5_OC5CON.setOCTSEL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TOCMP5_OC5CON.getOCTSEL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TOCMP5_OC5CON.setOCFLT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TOCMP5_OC5CON.clearOCFLT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TOCMP5_OC5CON.setOCFLT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TOCMP5_OC5CON.getOCFLT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TOCMP5_OC5CON.setOC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TOCMP5_OC5CON.clearOC32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TOCMP5_OC5CON.setOC32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TOCMP5_OC5CON.getOC32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TOCMP5_OC5CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TOCMP5_OC5CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TOCMP5_OC5CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TOCMP5_OC5CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TOCMP5_OC5CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TOCMP5_OC5CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TOCMP5_OC5CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TOCMP5_OC5CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TOCMP5_OC5CON.setOCM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TOCMP5_OC5CON.clearOCM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TOCMP5_OC5CON.setOCM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TOCMP5_OC5CON.getOCM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TOCMP5_OC5CON.setOCM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TOCMP5_OC5CON.clearOCM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TOCMP5_OC5CON.setOCM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TOCMP5_OC5CON.getOCM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TOCMP5_OC5CON.setOCM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TOCMP5_OC5CON.clearOCM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TOCMP5_OC5CON.setOCM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TOCMP5_OC5CON.getOCM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TOCMP5_OC5CON.setOCSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TOCMP5_OC5CON.clearOCSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TOCMP5_OC5CON.setOCSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TOCMP5_OC5CON.getOCSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TOCMP5_OC5CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TOCMP5_OC5CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TI2C1_I2C1CON.setSEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearSEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setSEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getSEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TI2C1_I2C1CON.setRSEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearRSEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setRSEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getRSEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TI2C1_I2C1CON.setPEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearPEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setPEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getPEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TI2C1_I2C1CON.setRCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearRCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setRCEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getRCEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TI2C1_I2C1CON.setACKEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearACKEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setACKEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getACKEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TI2C1_I2C1CON.setACKDT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearACKDT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setACKDT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getACKDT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TI2C1_I2C1CON.setSTREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearSTREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setSTREN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getSTREN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TI2C1_I2C1CON.setGCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearGCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setGCEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getGCEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TI2C1_I2C1CON.setSMEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearSMEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setSMEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getSMEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TI2C1_I2C1CON.setDISSLW; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearDISSLW; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setDISSLW(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getDISSLW : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TI2C1_I2C1CON.setA10M; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearA10M; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setA10M(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getA10M : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TI2C1_I2C1CON.setSTRICT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearSTRICT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setSTRICT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getSTRICT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TI2C1_I2C1CON.setSCLREL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearSCLREL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setSCLREL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getSCLREL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TI2C1_I2C1CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TI2C1_I2C1CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TI2C1_I2C1CON.setIPMIEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearIPMIEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setIPMIEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getIPMIEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TI2C1_I2C1CON.setI2CSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearI2CSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setI2CSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getI2CSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TI2C1_I2C1CON.setI2CEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1CON.clearI2CEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1CON.setI2CEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1CON.getI2CEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TI2C1_I2C1CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TI2C1_I2C1CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TI2C1_I2C1STAT.setTBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearTBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setTBF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getTBF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TI2C1_I2C1STAT.setRBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearRBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setRBF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getRBF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TI2C1_I2C1STAT.setR_W; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearR_W; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setR_W(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getR_W : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TI2C1_I2C1STAT.setS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TI2C1_I2C1STAT.setP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TI2C1_I2C1STAT.setD_A; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearD_A; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setD_A(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getD_A : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TI2C1_I2C1STAT.setI2COV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearI2COV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setI2COV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getI2COV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TI2C1_I2C1STAT.setIWCOL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearIWCOL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setIWCOL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getIWCOL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TI2C1_I2C1STAT.setADD10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearADD10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setADD10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getADD10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TI2C1_I2C1STAT.setGCSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearGCSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setGCSTAT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getGCSTAT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TI2C1_I2C1STAT.setBCL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearBCL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setBCL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getBCL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TI2C1_I2C1STAT.setTRSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearTRSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setTRSTAT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getTRSTAT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TI2C1_I2C1STAT.setACKSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearACKSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setACKSTAT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getACKSTAT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TI2C1_I2C1STAT.setI2CPOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TI2C1_I2C1STAT.clearI2CPOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TI2C1_I2C1STAT.setI2CPOV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TI2C1_I2C1STAT.getI2CPOV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TI2C1_I2C1STAT.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TI2C1_I2C1STAT.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TI2C2_I2C2CON.setSEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearSEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setSEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getSEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TI2C2_I2C2CON.setRSEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearRSEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setRSEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getRSEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TI2C2_I2C2CON.setPEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearPEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setPEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getPEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TI2C2_I2C2CON.setRCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearRCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setRCEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getRCEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TI2C2_I2C2CON.setACKEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearACKEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setACKEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getACKEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TI2C2_I2C2CON.setACKDT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearACKDT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setACKDT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getACKDT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TI2C2_I2C2CON.setSTREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearSTREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setSTREN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getSTREN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TI2C2_I2C2CON.setGCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearGCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setGCEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getGCEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TI2C2_I2C2CON.setSMEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearSMEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setSMEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getSMEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TI2C2_I2C2CON.setDISSLW; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearDISSLW; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setDISSLW(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getDISSLW : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TI2C2_I2C2CON.setA10M; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearA10M; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setA10M(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getA10M : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TI2C2_I2C2CON.setSTRICT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearSTRICT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setSTRICT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getSTRICT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TI2C2_I2C2CON.setSCLREL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearSCLREL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setSCLREL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getSCLREL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TI2C2_I2C2CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TI2C2_I2C2CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TI2C2_I2C2CON.setIPMIEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearIPMIEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setIPMIEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getIPMIEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TI2C2_I2C2CON.setI2CSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearI2CSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setI2CSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getI2CSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TI2C2_I2C2CON.setI2CEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2CON.clearI2CEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2CON.setI2CEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2CON.getI2CEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TI2C2_I2C2CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TI2C2_I2C2CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TI2C2_I2C2STAT.setTBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearTBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setTBF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getTBF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TI2C2_I2C2STAT.setRBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearRBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setRBF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getRBF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TI2C2_I2C2STAT.setR_W; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearR_W; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setR_W(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getR_W : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TI2C2_I2C2STAT.setS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TI2C2_I2C2STAT.setP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TI2C2_I2C2STAT.setD_A; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearD_A; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setD_A(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getD_A : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TI2C2_I2C2STAT.setI2COV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearI2COV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setI2COV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getI2COV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TI2C2_I2C2STAT.setIWCOL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearIWCOL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setIWCOL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getIWCOL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TI2C2_I2C2STAT.setADD10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearADD10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setADD10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getADD10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TI2C2_I2C2STAT.setGCSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearGCSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setGCSTAT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getGCSTAT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TI2C2_I2C2STAT.setBCL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearBCL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setBCL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getBCL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TI2C2_I2C2STAT.setTRSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearTRSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setTRSTAT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getTRSTAT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TI2C2_I2C2STAT.setACKSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearACKSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setACKSTAT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getACKSTAT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TI2C2_I2C2STAT.setI2CPOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TI2C2_I2C2STAT.clearI2CPOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TI2C2_I2C2STAT.setI2CPOV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TI2C2_I2C2STAT.getI2CPOV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TI2C2_I2C2STAT.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TI2C2_I2C2STAT.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TSPI2_SPI2CON.setMSTEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearMSTEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setMSTEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getMSTEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TSPI2_SPI2CON.setCKP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearCKP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setCKP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getCKP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TSPI2_SPI2CON.setSSEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearSSEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setSSEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getSSEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TSPI2_SPI2CON.setCKE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearCKE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setCKE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getCKE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TSPI2_SPI2CON.setSMP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearSMP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setSMP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getSMP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TSPI2_SPI2CON.setMODE16; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearMODE16; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setMODE16(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getMODE16 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TSPI2_SPI2CON.setMODE32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearMODE32; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setMODE32(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getMODE32 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TSPI2_SPI2CON.setDISSDO; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearDISSDO; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setDISSDO(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getDISSDO : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TSPI2_SPI2CON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TSPI2_SPI2CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TSPI2_SPI2CON.setSPIFE; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearSPIFE; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setSPIFE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,17,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getSPIFE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,17,1
end;
procedure TSPI2_SPI2CON.setFRMPOL; assembler; nostackframe; inline;
asm
  lui     $a1,8192
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearFRMPOL; assembler; nostackframe; inline;
asm
  lui     $a1,8192
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setFRMPOL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,29,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getFRMPOL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,29,1
end;
procedure TSPI2_SPI2CON.setFRMSYNC; assembler; nostackframe; inline;
asm
  lui     $a1,16384
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearFRMSYNC; assembler; nostackframe; inline;
asm
  lui     $a1,16384
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setFRMSYNC(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,30,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getFRMSYNC : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,30,1
end;
procedure TSPI2_SPI2CON.setFRMEN; assembler; nostackframe; inline;
asm
  lui     $a1,32768
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2CON.clearFRMEN; assembler; nostackframe; inline;
asm
  lui     $a1,32768
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2CON.setFRMEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,31,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2CON.getFRMEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,31,1
end;
procedure TSPI2_SPI2CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TSPI2_SPI2CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TSPI2_SPI2STAT.setSPIRBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2STAT.clearSPIRBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2STAT.setSPIRBF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2STAT.getSPIRBF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TSPI2_SPI2STAT.setSPITBE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2STAT.clearSPITBE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2STAT.setSPITBE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2STAT.getSPITBE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TSPI2_SPI2STAT.setSPIROV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2STAT.clearSPIROV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2STAT.setSPIROV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2STAT.getSPIROV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TSPI2_SPI2STAT.setSPIBUSY; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TSPI2_SPI2STAT.clearSPIBUSY; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TSPI2_SPI2STAT.setSPIBUSY(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TSPI2_SPI2STAT.getSPIBUSY : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TSPI2_SPI2STAT.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TSPI2_SPI2STAT.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TUART1_U1MODE.setSTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearSTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setSTSEL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getSTSEL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUART1_U1MODE.setPDSEL(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,2
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getPDSEL : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,2
end;
procedure TUART1_U1MODE.setBRGH; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearBRGH; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setBRGH(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getBRGH : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUART1_U1MODE.setRXINV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearRXINV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setRXINV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getRXINV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUART1_U1MODE.setABAUD; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearABAUD; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setABAUD(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getABAUD : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUART1_U1MODE.setLPBACK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearLPBACK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setLPBACK(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getLPBACK : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUART1_U1MODE.setWAKE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearWAKE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setWAKE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getWAKE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TUART1_U1MODE.setUEN(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,2
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getUEN : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,2
end;
procedure TUART1_U1MODE.setRTSMD; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearRTSMD; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setRTSMD(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getRTSMD : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TUART1_U1MODE.setIREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearIREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setIREN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getIREN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TUART1_U1MODE.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TUART1_U1MODE.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TUART1_U1MODE.setPDSEL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearPDSEL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setPDSEL0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getPDSEL0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUART1_U1MODE.setPDSEL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearPDSEL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setPDSEL1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getPDSEL1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUART1_U1MODE.setUEN0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearUEN0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setUEN0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getUEN0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TUART1_U1MODE.setUEN1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearUEN1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setUEN1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getUEN1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TUART1_U1MODE.setUSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearUSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setUSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getUSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TUART1_U1MODE.setUARTEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TUART1_U1MODE.clearUARTEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TUART1_U1MODE.setUARTEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TUART1_U1MODE.getUARTEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TUART1_U1MODE.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TUART1_U1MODE.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TUART1_U1STA.setURXDA; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearURXDA; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setURXDA(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getURXDA : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUART1_U1STA.setOERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearOERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setOERR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getOERR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUART1_U1STA.setFERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearFERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setFERR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getFERR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUART1_U1STA.setPERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearPERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setPERR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getPERR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUART1_U1STA.setRIDLE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearRIDLE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setRIDLE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getRIDLE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUART1_U1STA.setADDEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearADDEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setADDEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getADDEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUART1_U1STA.setURXISEL(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,2
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getURXISEL : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,2
end;
procedure TUART1_U1STA.setTRMT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearTRMT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setTRMT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getTRMT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TUART1_U1STA.setUTXBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearUTXBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setUTXBF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getUTXBF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TUART1_U1STA.setUTXEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearUTXEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setUTXEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getUTXEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TUART1_U1STA.setUTXBRK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearUTXBRK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setUTXBRK(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getUTXBRK : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TUART1_U1STA.setURXEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearURXEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setURXEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getURXEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TUART1_U1STA.setUTXINV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearUTXINV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setUTXINV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getUTXINV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TUART1_U1STA.setUTXISEL(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,2
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getUTXISEL : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,2
end;
procedure TUART1_U1STA.setADDR(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,16
  lui    $v0,65280
  ori    $v0,$v0,65535
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TUART1_U1STA.getADDR : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,16
  lui    $v0,255
  and    $a1,$a1,$v0
end;
procedure TUART1_U1STA.setADM_EN; assembler; nostackframe; inline;
asm
  lui     $a1,256
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearADM_EN; assembler; nostackframe; inline;
asm
  lui     $a1,256
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setADM_EN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,24,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getADM_EN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,24,1
end;
procedure TUART1_U1STA.setURXISEL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearURXISEL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setURXISEL0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getURXISEL0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUART1_U1STA.setURXISEL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearURXISEL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setURXISEL1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getURXISEL1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TUART1_U1STA.setUTXISEL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearUTXISEL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setUTXISEL0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getUTXISEL0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TUART1_U1STA.setUTXISEL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TUART1_U1STA.clearUTXISEL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TUART1_U1STA.setUTXISEL1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getUTXISEL1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TUART1_U1STA.setUTXSEL(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,2
  sw      $v1,($a0)
end;
function  TUART1_U1STA.getUTXSEL : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,2
end;
procedure TUART1_U1STA.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TUART1_U1STA.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TUART2_U2MODE.setSTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearSTSEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setSTSEL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getSTSEL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUART2_U2MODE.setPDSEL(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,2
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getPDSEL : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,2
end;
procedure TUART2_U2MODE.setBRGH; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearBRGH; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setBRGH(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getBRGH : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUART2_U2MODE.setRXINV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearRXINV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setRXINV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getRXINV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUART2_U2MODE.setABAUD; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearABAUD; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setABAUD(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getABAUD : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUART2_U2MODE.setLPBACK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearLPBACK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setLPBACK(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getLPBACK : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUART2_U2MODE.setWAKE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearWAKE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setWAKE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getWAKE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TUART2_U2MODE.setUEN(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,2
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getUEN : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,2
end;
procedure TUART2_U2MODE.setRTSMD; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearRTSMD; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setRTSMD(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getRTSMD : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TUART2_U2MODE.setIREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearIREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setIREN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getIREN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TUART2_U2MODE.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TUART2_U2MODE.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TUART2_U2MODE.setPDSEL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearPDSEL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setPDSEL0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getPDSEL0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUART2_U2MODE.setPDSEL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearPDSEL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setPDSEL1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getPDSEL1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUART2_U2MODE.setUEN0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearUEN0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setUEN0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getUEN0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TUART2_U2MODE.setUEN1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearUEN1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setUEN1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getUEN1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TUART2_U2MODE.setUSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearUSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setUSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getUSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TUART2_U2MODE.setUARTEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TUART2_U2MODE.clearUARTEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TUART2_U2MODE.setUARTEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TUART2_U2MODE.getUARTEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TUART2_U2MODE.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TUART2_U2MODE.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TUART2_U2STA.setURXDA; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearURXDA; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setURXDA(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getURXDA : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUART2_U2STA.setOERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearOERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setOERR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getOERR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUART2_U2STA.setFERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearFERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setFERR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getFERR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUART2_U2STA.setPERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearPERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setPERR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getPERR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUART2_U2STA.setRIDLE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearRIDLE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setRIDLE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getRIDLE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUART2_U2STA.setADDEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearADDEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setADDEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getADDEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUART2_U2STA.setURXISEL(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,2
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getURXISEL : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,2
end;
procedure TUART2_U2STA.setTRMT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearTRMT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setTRMT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getTRMT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TUART2_U2STA.setUTXBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearUTXBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setUTXBF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getUTXBF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TUART2_U2STA.setUTXEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearUTXEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setUTXEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getUTXEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TUART2_U2STA.setUTXBRK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearUTXBRK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setUTXBRK(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getUTXBRK : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TUART2_U2STA.setURXEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearURXEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setURXEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getURXEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TUART2_U2STA.setUTXINV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearUTXINV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setUTXINV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getUTXINV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TUART2_U2STA.setUTXISEL(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,2
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getUTXISEL : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,2
end;
procedure TUART2_U2STA.setADDR(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,16
  lui    $v0,65280
  ori    $v0,$v0,65535
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TUART2_U2STA.getADDR : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,16
  lui    $v0,255
  and    $a1,$a1,$v0
end;
procedure TUART2_U2STA.setADM_EN; assembler; nostackframe; inline;
asm
  lui     $a1,256
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearADM_EN; assembler; nostackframe; inline;
asm
  lui     $a1,256
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setADM_EN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,24,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getADM_EN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,24,1
end;
procedure TUART2_U2STA.setURXISEL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearURXISEL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setURXISEL0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getURXISEL0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUART2_U2STA.setURXISEL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearURXISEL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setURXISEL1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getURXISEL1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TUART2_U2STA.setUTXISEL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearUTXISEL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setUTXISEL0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getUTXISEL0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TUART2_U2STA.setUTXISEL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TUART2_U2STA.clearUTXISEL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TUART2_U2STA.setUTXISEL1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getUTXISEL1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TUART2_U2STA.setUTXSEL(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,2
  sw      $v1,($a0)
end;
function  TUART2_U2STA.getUTXSEL : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,2
end;
procedure TUART2_U2STA.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TUART2_U2STA.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPMP_PMCON.setRDSP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearRDSP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setRDSP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getRDSP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPMP_PMCON.setWRSP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearWRSP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setWRSP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getWRSP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPMP_PMCON.setCS1P; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearCS1P; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setCS1P(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getCS1P : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPMP_PMCON.setCS2P; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearCS2P; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setCS2P(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getCS2P : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPMP_PMCON.setALP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearALP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setALP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getALP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPMP_PMCON.setCSF(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,2
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getCSF : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,2
end;
procedure TPMP_PMCON.setPTRDEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearPTRDEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setPTRDEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getPTRDEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPMP_PMCON.setPTWREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearPTWREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setPTWREN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getPTWREN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPMP_PMCON.setPMPTTL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearPMPTTL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setPMPTTL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getPMPTTL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPMP_PMCON.setADRMUX(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,2
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getADRMUX : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,2
end;
procedure TPMP_PMCON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPMP_PMCON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPMP_PMCON.setCSF0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearCSF0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setCSF0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getCSF0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPMP_PMCON.setCSF1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearCSF1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setCSF1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getCSF1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPMP_PMCON.setADRMUX0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearADRMUX0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setADRMUX0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getADRMUX0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPMP_PMCON.setADRMUX1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearADRMUX1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setADRMUX1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getADRMUX1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPMP_PMCON.setPSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearPSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setPSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getPSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPMP_PMCON.setPMPEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPMP_PMCON.clearPMPEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPMP_PMCON.setPMPEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPMP_PMCON.getPMPEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPMP_PMCON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPMP_PMCON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPMP_PMMODE.setWAITE(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,2
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getWAITE : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,2
end;
procedure TPMP_PMMODE.setWAITM(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,4
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getWAITM : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,4
end;
procedure TPMP_PMMODE.setWAITB(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,2
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getWAITB : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,2
end;
procedure TPMP_PMMODE.setMODE(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,2
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getMODE : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,2
end;
procedure TPMP_PMMODE.setMODE16; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearMODE16; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setMODE16(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getMODE16 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPMP_PMMODE.setINCM(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,2
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getINCM : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,2
end;
procedure TPMP_PMMODE.setIRQM(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,2
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getIRQM : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,2
end;
procedure TPMP_PMMODE.setBUSY; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearBUSY; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setBUSY(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getBUSY : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPMP_PMMODE.setWAITE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearWAITE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setWAITE0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getWAITE0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPMP_PMMODE.setWAITE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearWAITE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setWAITE1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getWAITE1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPMP_PMMODE.setWAITM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearWAITM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setWAITM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getWAITM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPMP_PMMODE.setWAITM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearWAITM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setWAITM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getWAITM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPMP_PMMODE.setWAITM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearWAITM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setWAITM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getWAITM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPMP_PMMODE.setWAITM3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearWAITM3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setWAITM3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getWAITM3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPMP_PMMODE.setWAITB0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearWAITB0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setWAITB0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getWAITB0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPMP_PMMODE.setWAITB1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearWAITB1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setWAITB1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getWAITB1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPMP_PMMODE.setMODE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearMODE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setMODE0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getMODE0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPMP_PMMODE.setMODE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearMODE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setMODE1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getMODE1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPMP_PMMODE.setINCM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearINCM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setINCM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getINCM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPMP_PMMODE.setINCM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearINCM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setINCM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getINCM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPMP_PMMODE.setIRQM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearIRQM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setIRQM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getIRQM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPMP_PMMODE.setIRQM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPMP_PMMODE.clearIRQM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPMP_PMMODE.setIRQM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPMP_PMMODE.getIRQM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPMP_PMMODE.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPMP_PMMODE.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPMP_PMADDR.setADDR(thebits : TBits_14); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,0
  lui    $v0,65535
  ori    $v0,$v0,49152
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TPMP_PMADDR.getADDR : TBits_14;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,0
  ori    $v0,$zero,16383
  and    $a1,$a1,$v0
end;
procedure TPMP_PMADDR.setCS(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,2
  sw      $v1,($a0)
end;
function  TPMP_PMADDR.getCS : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,2
end;
procedure TPMP_PMADDR.setPADDR(thebits : TBits_14); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,0
  lui    $v0,65535
  ori    $v0,$v0,49152
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TPMP_PMADDR.getPADDR : TBits_14;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,0
  ori    $v0,$zero,16383
  and    $a1,$a1,$v0
end;
procedure TPMP_PMADDR.setCS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPMP_PMADDR.clearCS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPMP_PMADDR.setCS1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPMP_PMADDR.getCS1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPMP_PMADDR.setCS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPMP_PMADDR.clearCS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPMP_PMADDR.setCS2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPMP_PMADDR.getCS2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPMP_PMADDR.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPMP_PMADDR.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPMP_PMDOUT.setDATAOUT(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPMP_PMDOUT.getDATAOUT : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPMP_PMDOUT.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPMP_PMDOUT.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPMP_PMDIN.setDATAIN(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPMP_PMDIN.getDATAIN : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPMP_PMDIN.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPMP_PMDIN.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPMP_PMAEN.setPTEN(thebits : TBits_16); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,0
  lui    $v0,65535
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TPMP_PMAEN.getPTEN : TBits_16;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,0
  ori    $v0,$zero,65535
  and    $a1,$a1,$v0
end;
procedure TPMP_PMAEN.setPTEN0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPMP_PMAEN.setPTEN1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPMP_PMAEN.setPTEN2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPMP_PMAEN.setPTEN3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPMP_PMAEN.setPTEN4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPMP_PMAEN.setPTEN5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPMP_PMAEN.setPTEN6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPMP_PMAEN.setPTEN7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPMP_PMAEN.setPTEN8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPMP_PMAEN.setPTEN9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPMP_PMAEN.setPTEN10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPMP_PMAEN.setPTEN11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPMP_PMAEN.setPTEN12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPMP_PMAEN.setPTEN13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPMP_PMAEN.setPTEN14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPMP_PMAEN.setPTEN15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPMP_PMAEN.clearPTEN15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPMP_PMAEN.setPTEN15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPMP_PMAEN.getPTEN15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPMP_PMAEN.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPMP_PMAEN.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPMP_PMSTAT.setOB0E; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPMP_PMSTAT.clearOB0E; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPMP_PMSTAT.setOB0E(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPMP_PMSTAT.getOB0E : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPMP_PMSTAT.setOB1E; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPMP_PMSTAT.clearOB1E; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPMP_PMSTAT.setOB1E(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPMP_PMSTAT.getOB1E : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPMP_PMSTAT.setOB2E; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPMP_PMSTAT.clearOB2E; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPMP_PMSTAT.setOB2E(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPMP_PMSTAT.getOB2E : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPMP_PMSTAT.setOB3E; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPMP_PMSTAT.clearOB3E; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPMP_PMSTAT.setOB3E(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPMP_PMSTAT.getOB3E : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPMP_PMSTAT.setOBUF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPMP_PMSTAT.clearOBUF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPMP_PMSTAT.setOBUF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPMP_PMSTAT.getOBUF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPMP_PMSTAT.setOBE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPMP_PMSTAT.clearOBE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPMP_PMSTAT.setOBE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPMP_PMSTAT.getOBE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPMP_PMSTAT.setIB0F; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPMP_PMSTAT.clearIB0F; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPMP_PMSTAT.setIB0F(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPMP_PMSTAT.getIB0F : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPMP_PMSTAT.setIB1F; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPMP_PMSTAT.clearIB1F; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPMP_PMSTAT.setIB1F(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPMP_PMSTAT.getIB1F : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPMP_PMSTAT.setIB2F; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPMP_PMSTAT.clearIB2F; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPMP_PMSTAT.setIB2F(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPMP_PMSTAT.getIB2F : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPMP_PMSTAT.setIB3F; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPMP_PMSTAT.clearIB3F; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPMP_PMSTAT.setIB3F(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPMP_PMSTAT.getIB3F : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPMP_PMSTAT.setIBOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPMP_PMSTAT.clearIBOV; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPMP_PMSTAT.setIBOV(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPMP_PMSTAT.getIBOV : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPMP_PMSTAT.setIBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPMP_PMSTAT.clearIBF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPMP_PMSTAT.setIBF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPMP_PMSTAT.getIBF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPMP_PMSTAT.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPMP_PMSTAT.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TADC10_AD1CON1.setDONE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearDONE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setDONE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getDONE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TADC10_AD1CON1.setSAMP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearSAMP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setSAMP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getSAMP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TADC10_AD1CON1.setASAM; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearASAM; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setASAM(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getASAM : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TADC10_AD1CON1.setCLRASAM; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearCLRASAM; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setCLRASAM(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getCLRASAM : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TADC10_AD1CON1.setSSRC(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,3
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getSSRC : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,3
end;
procedure TADC10_AD1CON1.setFORM(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,3
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getFORM : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,3
end;
procedure TADC10_AD1CON1.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TADC10_AD1CON1.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TADC10_AD1CON1.setSSRC0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearSSRC0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setSSRC0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getSSRC0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TADC10_AD1CON1.setSSRC1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearSSRC1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setSSRC1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getSSRC1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TADC10_AD1CON1.setSSRC2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearSSRC2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setSSRC2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getSSRC2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TADC10_AD1CON1.setFORM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearFORM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setFORM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getFORM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TADC10_AD1CON1.setFORM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearFORM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setFORM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getFORM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TADC10_AD1CON1.setFORM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearFORM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setFORM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getFORM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TADC10_AD1CON1.setADSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearADSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setADSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getADSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TADC10_AD1CON1.setADON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON1.clearADON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON1.setADON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON1.getADON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TADC10_AD1CON1.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TADC10_AD1CON1.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TADC10_AD1CON2.setALTS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON2.clearALTS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON2.setALTS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getALTS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TADC10_AD1CON2.setBUFM; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON2.clearBUFM; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON2.setBUFM(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getBUFM : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TADC10_AD1CON2.setSMPI(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,4
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getSMPI : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,4
end;
procedure TADC10_AD1CON2.setBUFS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON2.clearBUFS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON2.setBUFS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getBUFS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TADC10_AD1CON2.setCSCNA; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON2.clearCSCNA; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON2.setCSCNA(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getCSCNA : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TADC10_AD1CON2.setOFFCAL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON2.clearOFFCAL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON2.setOFFCAL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getOFFCAL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TADC10_AD1CON2.setVCFG(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,3
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getVCFG : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,3
end;
procedure TADC10_AD1CON2.setSMPI0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON2.clearSMPI0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON2.setSMPI0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getSMPI0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TADC10_AD1CON2.setSMPI1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON2.clearSMPI1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON2.setSMPI1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getSMPI1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TADC10_AD1CON2.setSMPI2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON2.clearSMPI2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON2.setSMPI2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getSMPI2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TADC10_AD1CON2.setSMPI3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON2.clearSMPI3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON2.setSMPI3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getSMPI3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TADC10_AD1CON2.setVCFG0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON2.clearVCFG0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON2.setVCFG0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getVCFG0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TADC10_AD1CON2.setVCFG1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON2.clearVCFG1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON2.setVCFG1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getVCFG1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TADC10_AD1CON2.setVCFG2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON2.clearVCFG2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON2.setVCFG2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON2.getVCFG2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TADC10_AD1CON2.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TADC10_AD1CON2.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TADC10_AD1CON3.setADCS(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,0
  lui    $v0,65535
  ori    $v0,$v0,65280
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TADC10_AD1CON3.getADCS : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,0
  ori    $v0,$zero,255
  and    $a1,$a1,$v0
end;
procedure TADC10_AD1CON3.setSAMC(thebits : TBits_5); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,5
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getSAMC : TBits_5;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,5
end;
procedure TADC10_AD1CON3.setADRC; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearADRC; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setADRC(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getADRC : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TADC10_AD1CON3.setADCS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearADCS0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setADCS0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getADCS0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TADC10_AD1CON3.setADCS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearADCS1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setADCS1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getADCS1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TADC10_AD1CON3.setADCS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearADCS2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setADCS2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getADCS2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TADC10_AD1CON3.setADCS3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearADCS3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setADCS3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getADCS3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TADC10_AD1CON3.setADCS4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearADCS4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setADCS4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getADCS4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TADC10_AD1CON3.setADCS5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearADCS5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setADCS5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getADCS5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TADC10_AD1CON3.setADCS6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearADCS6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setADCS6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getADCS6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TADC10_AD1CON3.setADCS7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearADCS7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setADCS7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getADCS7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TADC10_AD1CON3.setSAMC0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearSAMC0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setSAMC0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getSAMC0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TADC10_AD1CON3.setSAMC1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearSAMC1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setSAMC1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getSAMC1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TADC10_AD1CON3.setSAMC2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearSAMC2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setSAMC2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getSAMC2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TADC10_AD1CON3.setSAMC3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearSAMC3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setSAMC3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getSAMC3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TADC10_AD1CON3.setSAMC4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TADC10_AD1CON3.clearSAMC4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TADC10_AD1CON3.setSAMC4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CON3.getSAMC4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TADC10_AD1CON3.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TADC10_AD1CON3.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TADC10_AD1CHS.setCH0SA(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,4
  sw      $v1,($a0)
end;
function  TADC10_AD1CHS.getCH0SA : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,4
end;
procedure TADC10_AD1CHS.setCH0NA; assembler; nostackframe; inline;
asm
  lui     $a1,128
  sw $a1,8($a0)
end;
procedure TADC10_AD1CHS.clearCH0NA; assembler; nostackframe; inline;
asm
  lui     $a1,128
  sw $a1,4($a0)
end;
procedure TADC10_AD1CHS.setCH0NA(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,23,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CHS.getCH0NA : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,23,1
end;
procedure TADC10_AD1CHS.setCH0SB(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,24,4
  sw      $v1,($a0)
end;
function  TADC10_AD1CHS.getCH0SB : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,24,4
end;
procedure TADC10_AD1CHS.setCH0NB; assembler; nostackframe; inline;
asm
  lui     $a1,32768
  sw $a1,8($a0)
end;
procedure TADC10_AD1CHS.clearCH0NB; assembler; nostackframe; inline;
asm
  lui     $a1,32768
  sw $a1,4($a0)
end;
procedure TADC10_AD1CHS.setCH0NB(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,31,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CHS.getCH0NB : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,31,1
end;
procedure TADC10_AD1CHS.setCH0SA0; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,8($a0)
end;
procedure TADC10_AD1CHS.clearCH0SA0; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,4($a0)
end;
procedure TADC10_AD1CHS.setCH0SA0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CHS.getCH0SA0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,1
end;
procedure TADC10_AD1CHS.setCH0SA1; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,8($a0)
end;
procedure TADC10_AD1CHS.clearCH0SA1; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,4($a0)
end;
procedure TADC10_AD1CHS.setCH0SA1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,17,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CHS.getCH0SA1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,17,1
end;
procedure TADC10_AD1CHS.setCH0SA2; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,8($a0)
end;
procedure TADC10_AD1CHS.clearCH0SA2; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,4($a0)
end;
procedure TADC10_AD1CHS.setCH0SA2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,18,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CHS.getCH0SA2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,18,1
end;
procedure TADC10_AD1CHS.setCH0SA3; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,8($a0)
end;
procedure TADC10_AD1CHS.clearCH0SA3; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,4($a0)
end;
procedure TADC10_AD1CHS.setCH0SA3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,19,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CHS.getCH0SA3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,19,1
end;
procedure TADC10_AD1CHS.setCH0SB0; assembler; nostackframe; inline;
asm
  lui     $a1,256
  sw $a1,8($a0)
end;
procedure TADC10_AD1CHS.clearCH0SB0; assembler; nostackframe; inline;
asm
  lui     $a1,256
  sw $a1,4($a0)
end;
procedure TADC10_AD1CHS.setCH0SB0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,24,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CHS.getCH0SB0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,24,1
end;
procedure TADC10_AD1CHS.setCH0SB1; assembler; nostackframe; inline;
asm
  lui     $a1,512
  sw $a1,8($a0)
end;
procedure TADC10_AD1CHS.clearCH0SB1; assembler; nostackframe; inline;
asm
  lui     $a1,512
  sw $a1,4($a0)
end;
procedure TADC10_AD1CHS.setCH0SB1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,25,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CHS.getCH0SB1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,25,1
end;
procedure TADC10_AD1CHS.setCH0SB2; assembler; nostackframe; inline;
asm
  lui     $a1,1024
  sw $a1,8($a0)
end;
procedure TADC10_AD1CHS.clearCH0SB2; assembler; nostackframe; inline;
asm
  lui     $a1,1024
  sw $a1,4($a0)
end;
procedure TADC10_AD1CHS.setCH0SB2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,26,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CHS.getCH0SB2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,26,1
end;
procedure TADC10_AD1CHS.setCH0SB3; assembler; nostackframe; inline;
asm
  lui     $a1,2048
  sw $a1,8($a0)
end;
procedure TADC10_AD1CHS.clearCH0SB3; assembler; nostackframe; inline;
asm
  lui     $a1,2048
  sw $a1,4($a0)
end;
procedure TADC10_AD1CHS.setCH0SB3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,27,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CHS.getCH0SB3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,27,1
end;
procedure TADC10_AD1CHS.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TADC10_AD1CHS.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TADC10_AD1CSSL.setCSSL(thebits : TBits_16); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,0
  lui    $v0,65535
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL : TBits_16;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,0
  ori    $v0,$zero,65535
  and    $a1,$a1,$v0
end;
procedure TADC10_AD1CSSL.setCSSL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TADC10_AD1CSSL.setCSSL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TADC10_AD1CSSL.setCSSL2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TADC10_AD1CSSL.setCSSL3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TADC10_AD1CSSL.setCSSL4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TADC10_AD1CSSL.setCSSL5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TADC10_AD1CSSL.setCSSL6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TADC10_AD1CSSL.setCSSL7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TADC10_AD1CSSL.setCSSL8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TADC10_AD1CSSL.setCSSL9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TADC10_AD1CSSL.setCSSL10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TADC10_AD1CSSL.setCSSL11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TADC10_AD1CSSL.setCSSL12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TADC10_AD1CSSL.setCSSL13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TADC10_AD1CSSL.setCSSL14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TADC10_AD1CSSL.setCSSL15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TADC10_AD1CSSL.clearCSSL15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TADC10_AD1CSSL.setCSSL15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TADC10_AD1CSSL.getCSSL15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TADC10_AD1CSSL.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TADC10_AD1CSSL.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TADC10_AD1PCFG.setPCFG(thebits : TBits_16); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,0
  lui    $v0,65535
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG : TBits_16;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,0
  ori    $v0,$zero,65535
  and    $a1,$a1,$v0
end;
procedure TADC10_AD1PCFG.setPCFG0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TADC10_AD1PCFG.setPCFG1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TADC10_AD1PCFG.setPCFG2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TADC10_AD1PCFG.setPCFG3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TADC10_AD1PCFG.setPCFG4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TADC10_AD1PCFG.setPCFG5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TADC10_AD1PCFG.setPCFG6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TADC10_AD1PCFG.setPCFG7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TADC10_AD1PCFG.setPCFG8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TADC10_AD1PCFG.setPCFG9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TADC10_AD1PCFG.setPCFG10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TADC10_AD1PCFG.setPCFG11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TADC10_AD1PCFG.setPCFG12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TADC10_AD1PCFG.setPCFG13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TADC10_AD1PCFG.setPCFG14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TADC10_AD1PCFG.setPCFG15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TADC10_AD1PCFG.clearPCFG15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TADC10_AD1PCFG.setPCFG15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TADC10_AD1PCFG.getPCFG15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TADC10_AD1PCFG.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TADC10_AD1PCFG.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TCVR_CVRCON.setCVR(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,4
  sw      $v1,($a0)
end;
function  TCVR_CVRCON.getCVR : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,4
end;
procedure TCVR_CVRCON.setCVRSS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TCVR_CVRCON.clearCVRSS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TCVR_CVRCON.setCVRSS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TCVR_CVRCON.getCVRSS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TCVR_CVRCON.setCVRR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TCVR_CVRCON.clearCVRR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TCVR_CVRCON.setCVRR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TCVR_CVRCON.getCVRR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TCVR_CVRCON.setCVROE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TCVR_CVRCON.clearCVROE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TCVR_CVRCON.setCVROE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TCVR_CVRCON.getCVROE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TCVR_CVRCON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TCVR_CVRCON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TCVR_CVRCON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TCVR_CVRCON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TCVR_CVRCON.setCVR0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TCVR_CVRCON.clearCVR0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TCVR_CVRCON.setCVR0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TCVR_CVRCON.getCVR0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TCVR_CVRCON.setCVR1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TCVR_CVRCON.clearCVR1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TCVR_CVRCON.setCVR1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TCVR_CVRCON.getCVR1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TCVR_CVRCON.setCVR2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TCVR_CVRCON.clearCVR2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TCVR_CVRCON.setCVR2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TCVR_CVRCON.getCVR2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TCVR_CVRCON.setCVR3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TCVR_CVRCON.clearCVR3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TCVR_CVRCON.setCVR3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TCVR_CVRCON.getCVR3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TCVR_CVRCON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TCVR_CVRCON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TCMP_CM1CON.setCCH(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,2
  sw      $v1,($a0)
end;
function  TCMP_CM1CON.getCCH : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,2
end;
procedure TCMP_CM1CON.setCREF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TCMP_CM1CON.clearCREF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TCMP_CM1CON.setCREF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TCMP_CM1CON.getCREF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TCMP_CM1CON.setEVPOL(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,2
  sw      $v1,($a0)
end;
function  TCMP_CM1CON.getEVPOL : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,2
end;
procedure TCMP_CM1CON.setCOUT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TCMP_CM1CON.clearCOUT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TCMP_CM1CON.setCOUT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TCMP_CM1CON.getCOUT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TCMP_CM1CON.setCPOL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TCMP_CM1CON.clearCPOL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TCMP_CM1CON.setCPOL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TCMP_CM1CON.getCPOL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TCMP_CM1CON.setCOE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TCMP_CM1CON.clearCOE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TCMP_CM1CON.setCOE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TCMP_CM1CON.getCOE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TCMP_CM1CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TCMP_CM1CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TCMP_CM1CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TCMP_CM1CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TCMP_CM1CON.setCCH0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TCMP_CM1CON.clearCCH0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TCMP_CM1CON.setCCH0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TCMP_CM1CON.getCCH0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TCMP_CM1CON.setCCH1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TCMP_CM1CON.clearCCH1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TCMP_CM1CON.setCCH1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TCMP_CM1CON.getCCH1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TCMP_CM1CON.setEVPOL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TCMP_CM1CON.clearEVPOL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TCMP_CM1CON.setEVPOL0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TCMP_CM1CON.getEVPOL0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TCMP_CM1CON.setEVPOL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TCMP_CM1CON.clearEVPOL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TCMP_CM1CON.setEVPOL1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TCMP_CM1CON.getEVPOL1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TCMP_CM1CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TCMP_CM1CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TCMP_CM2CON.setCCH(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,2
  sw      $v1,($a0)
end;
function  TCMP_CM2CON.getCCH : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,2
end;
procedure TCMP_CM2CON.setCREF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TCMP_CM2CON.clearCREF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TCMP_CM2CON.setCREF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TCMP_CM2CON.getCREF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TCMP_CM2CON.setEVPOL(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,2
  sw      $v1,($a0)
end;
function  TCMP_CM2CON.getEVPOL : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,2
end;
procedure TCMP_CM2CON.setCOUT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TCMP_CM2CON.clearCOUT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TCMP_CM2CON.setCOUT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TCMP_CM2CON.getCOUT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TCMP_CM2CON.setCPOL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TCMP_CM2CON.clearCPOL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TCMP_CM2CON.setCPOL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TCMP_CM2CON.getCPOL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TCMP_CM2CON.setCOE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TCMP_CM2CON.clearCOE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TCMP_CM2CON.setCOE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TCMP_CM2CON.getCOE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TCMP_CM2CON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TCMP_CM2CON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TCMP_CM2CON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TCMP_CM2CON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TCMP_CM2CON.setCCH0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TCMP_CM2CON.clearCCH0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TCMP_CM2CON.setCCH0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TCMP_CM2CON.getCCH0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TCMP_CM2CON.setCCH1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TCMP_CM2CON.clearCCH1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TCMP_CM2CON.setCCH1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TCMP_CM2CON.getCCH1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TCMP_CM2CON.setEVPOL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TCMP_CM2CON.clearEVPOL0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TCMP_CM2CON.setEVPOL0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TCMP_CM2CON.getEVPOL0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TCMP_CM2CON.setEVPOL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TCMP_CM2CON.clearEVPOL1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TCMP_CM2CON.setEVPOL1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TCMP_CM2CON.getEVPOL1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TCMP_CM2CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TCMP_CM2CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TCMP_CMSTAT.setC1OUT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TCMP_CMSTAT.clearC1OUT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TCMP_CMSTAT.setC1OUT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TCMP_CMSTAT.getC1OUT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TCMP_CMSTAT.setC2OUT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TCMP_CMSTAT.clearC2OUT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TCMP_CMSTAT.setC2OUT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TCMP_CMSTAT.getC2OUT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TCMP_CMSTAT.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TCMP_CMSTAT.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TCMP_CMSTAT.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TCMP_CMSTAT.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TCMP_CMSTAT.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TCMP_CMSTAT.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TOSC_OSCCON.setOSWEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearOSWEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setOSWEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getOSWEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TOSC_OSCCON.setSOSCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearSOSCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setSOSCEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getSOSCEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TOSC_OSCCON.setUFRCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearUFRCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setUFRCEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getUFRCEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TOSC_OSCCON.setCF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearCF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setCF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getCF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TOSC_OSCCON.setSLPEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearSLPEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setSLPEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getSLPEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TOSC_OSCCON.setLOCK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearLOCK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setLOCK(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getLOCK : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TOSC_OSCCON.setULOCK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearULOCK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setULOCK(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getULOCK : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TOSC_OSCCON.setCLKLOCK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearCLKLOCK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setCLKLOCK(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getCLKLOCK : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TOSC_OSCCON.setNOSC(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,3
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getNOSC : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,3
end;
procedure TOSC_OSCCON.setCOSC(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,3
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getCOSC : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,3
end;
procedure TOSC_OSCCON.setPLLMULT(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,3
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getPLLMULT : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,3
end;
procedure TOSC_OSCCON.setPBDIV(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,19,2
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getPBDIV : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,19,2
end;
procedure TOSC_OSCCON.setSOSCRDY; assembler; nostackframe; inline;
asm
  lui     $a1,64
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearSOSCRDY; assembler; nostackframe; inline;
asm
  lui     $a1,64
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setSOSCRDY(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,22,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getSOSCRDY : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,22,1
end;
procedure TOSC_OSCCON.setFRCDIV(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,24,3
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getFRCDIV : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,24,3
end;
procedure TOSC_OSCCON.setPLLODIV(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,27,3
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getPLLODIV : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,27,3
end;
procedure TOSC_OSCCON.setNOSC0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearNOSC0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setNOSC0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getNOSC0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TOSC_OSCCON.setNOSC1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearNOSC1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setNOSC1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getNOSC1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TOSC_OSCCON.setNOSC2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearNOSC2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setNOSC2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getNOSC2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TOSC_OSCCON.setCOSC0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearCOSC0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setCOSC0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getCOSC0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TOSC_OSCCON.setCOSC1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearCOSC1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setCOSC1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getCOSC1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TOSC_OSCCON.setCOSC2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearCOSC2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setCOSC2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getCOSC2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TOSC_OSCCON.setPLLMULT0; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearPLLMULT0; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setPLLMULT0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getPLLMULT0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,1
end;
procedure TOSC_OSCCON.setPLLMULT1; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearPLLMULT1; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setPLLMULT1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,17,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getPLLMULT1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,17,1
end;
procedure TOSC_OSCCON.setPLLMULT2; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearPLLMULT2; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setPLLMULT2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,18,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getPLLMULT2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,18,1
end;
procedure TOSC_OSCCON.setPBDIV0; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearPBDIV0; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setPBDIV0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,19,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getPBDIV0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,19,1
end;
procedure TOSC_OSCCON.setPBDIV1; assembler; nostackframe; inline;
asm
  lui     $a1,16
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearPBDIV1; assembler; nostackframe; inline;
asm
  lui     $a1,16
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setPBDIV1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,20,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getPBDIV1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,20,1
end;
procedure TOSC_OSCCON.setFRCDIV0; assembler; nostackframe; inline;
asm
  lui     $a1,256
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearFRCDIV0; assembler; nostackframe; inline;
asm
  lui     $a1,256
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setFRCDIV0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,24,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getFRCDIV0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,24,1
end;
procedure TOSC_OSCCON.setFRCDIV1; assembler; nostackframe; inline;
asm
  lui     $a1,512
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearFRCDIV1; assembler; nostackframe; inline;
asm
  lui     $a1,512
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setFRCDIV1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,25,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getFRCDIV1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,25,1
end;
procedure TOSC_OSCCON.setFRCDIV2; assembler; nostackframe; inline;
asm
  lui     $a1,1024
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearFRCDIV2; assembler; nostackframe; inline;
asm
  lui     $a1,1024
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setFRCDIV2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,26,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getFRCDIV2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,26,1
end;
procedure TOSC_OSCCON.setPLLODIV0; assembler; nostackframe; inline;
asm
  lui     $a1,2048
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearPLLODIV0; assembler; nostackframe; inline;
asm
  lui     $a1,2048
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setPLLODIV0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,27,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getPLLODIV0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,27,1
end;
procedure TOSC_OSCCON.setPLLODIV1; assembler; nostackframe; inline;
asm
  lui     $a1,4096
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearPLLODIV1; assembler; nostackframe; inline;
asm
  lui     $a1,4096
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setPLLODIV1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,28,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getPLLODIV1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,28,1
end;
procedure TOSC_OSCCON.setPLLODIV2; assembler; nostackframe; inline;
asm
  lui     $a1,8192
  sw $a1,8($a0)
end;
procedure TOSC_OSCCON.clearPLLODIV2; assembler; nostackframe; inline;
asm
  lui     $a1,8192
  sw $a1,4($a0)
end;
procedure TOSC_OSCCON.setPLLODIV2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,29,1
  sw      $v1,($a0)
end;
function  TOSC_OSCCON.getPLLODIV2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,29,1
end;
procedure TOSC_OSCCON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TOSC_OSCCON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TOSC_OSCTUN.setTUN(thebits : TBits_6); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,0
  lui    $v0,65535
  ori    $v0,$v0,65472
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TOSC_OSCTUN.getTUN : TBits_6;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,0
  ori    $v0,$zero,63
  and    $a1,$a1,$v0
end;
procedure TOSC_OSCTUN.setTUN0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TOSC_OSCTUN.clearTUN0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TOSC_OSCTUN.setTUN0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TOSC_OSCTUN.getTUN0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TOSC_OSCTUN.setTUN1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TOSC_OSCTUN.clearTUN1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TOSC_OSCTUN.setTUN1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TOSC_OSCTUN.getTUN1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TOSC_OSCTUN.setTUN2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TOSC_OSCTUN.clearTUN2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TOSC_OSCTUN.setTUN2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TOSC_OSCTUN.getTUN2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TOSC_OSCTUN.setTUN3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TOSC_OSCTUN.clearTUN3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TOSC_OSCTUN.setTUN3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TOSC_OSCTUN.getTUN3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TOSC_OSCTUN.setTUN4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TOSC_OSCTUN.clearTUN4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TOSC_OSCTUN.setTUN4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TOSC_OSCTUN.getTUN4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TOSC_OSCTUN.setTUN5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TOSC_OSCTUN.clearTUN5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TOSC_OSCTUN.setTUN5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TOSC_OSCTUN.getTUN5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TOSC_OSCTUN.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TOSC_OSCTUN.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TNVM_NVMCON.setNVMOP(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,4
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getNVMOP : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,4
end;
procedure TNVM_NVMCON.setLVDSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearLVDSTAT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setLVDSTAT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getLVDSTAT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TNVM_NVMCON.setLVDERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearLVDERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setLVDERR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getLVDERR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TNVM_NVMCON.setWRERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearWRERR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setWRERR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getWRERR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TNVM_NVMCON.setWREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearWREN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setWREN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getWREN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TNVM_NVMCON.setWR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearWR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setWR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getWR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TNVM_NVMCON.setNVMOP0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearNVMOP0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setNVMOP0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getNVMOP0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TNVM_NVMCON.setNVMOP1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearNVMOP1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setNVMOP1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getNVMOP1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TNVM_NVMCON.setNVMOP2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearNVMOP2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setNVMOP2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getNVMOP2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TNVM_NVMCON.setNVMOP3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearNVMOP3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setNVMOP3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getNVMOP3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TNVM_NVMCON.setPROGOP(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,4
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getPROGOP : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,4
end;
procedure TNVM_NVMCON.setPROGOP0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearPROGOP0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setPROGOP0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getPROGOP0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TNVM_NVMCON.setPROGOP1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearPROGOP1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setPROGOP1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getPROGOP1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TNVM_NVMCON.setPROGOP2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearPROGOP2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setPROGOP2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getPROGOP2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TNVM_NVMCON.setPROGOP3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TNVM_NVMCON.clearPROGOP3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TNVM_NVMCON.setPROGOP3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TNVM_NVMCON.getPROGOP3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TNVM_NVMCON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TNVM_NVMCON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TRCON_RCON.setPOR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TRCON_RCON.clearPOR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TRCON_RCON.setPOR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TRCON_RCON.getPOR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TRCON_RCON.setBOR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TRCON_RCON.clearBOR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TRCON_RCON.setBOR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TRCON_RCON.getBOR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TRCON_RCON.setIDLE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TRCON_RCON.clearIDLE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TRCON_RCON.setIDLE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TRCON_RCON.getIDLE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TRCON_RCON.setSLEEP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TRCON_RCON.clearSLEEP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TRCON_RCON.setSLEEP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TRCON_RCON.getSLEEP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TRCON_RCON.setWDTO; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TRCON_RCON.clearWDTO; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TRCON_RCON.setWDTO(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TRCON_RCON.getWDTO : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TRCON_RCON.setSWR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TRCON_RCON.clearSWR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TRCON_RCON.setSWR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TRCON_RCON.getSWR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TRCON_RCON.setEXTR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TRCON_RCON.clearEXTR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TRCON_RCON.setEXTR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TRCON_RCON.getEXTR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TRCON_RCON.setVREGS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TRCON_RCON.clearVREGS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TRCON_RCON.setVREGS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TRCON_RCON.getVREGS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TRCON_RCON.setCMR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TRCON_RCON.clearCMR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TRCON_RCON.setCMR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TRCON_RCON.getCMR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TRCON_RCON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TRCON_RCON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TRCON_RSWRST.setSWRST; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TRCON_RSWRST.clearSWRST; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TRCON_RSWRST.setSWRST(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TRCON_RSWRST.getSWRST : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TRCON_RSWRST.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TRCON_RSWRST.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TINT_INTSTAT.setVEC(thebits : TBits_6); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,0
  lui    $v0,65535
  ori    $v0,$v0,65472
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TINT_INTSTAT.getVEC : TBits_6;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,0
  ori    $v0,$zero,63
  and    $a1,$a1,$v0
end;
procedure TINT_INTSTAT.setRIPL(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,3
  sw      $v1,($a0)
end;
function  TINT_INTSTAT.getRIPL : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,3
end;
procedure TINT_INTSTAT.setSRIPL(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,3
  sw      $v1,($a0)
end;
function  TINT_INTSTAT.getSRIPL : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,3
end;
procedure TBMX_BMXCON.setBMXARB(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TBMX_BMXCON.getBMXARB : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TBMX_BMXCON.setBMXWSDRM; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TBMX_BMXCON.clearBMXWSDRM; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TBMX_BMXCON.setBMXWSDRM(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TBMX_BMXCON.getBMXWSDRM : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TBMX_BMXCON.setBMXERRIS; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,8($a0)
end;
procedure TBMX_BMXCON.clearBMXERRIS; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,4($a0)
end;
procedure TBMX_BMXCON.setBMXERRIS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,1
  sw      $v1,($a0)
end;
function  TBMX_BMXCON.getBMXERRIS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,1
end;
procedure TBMX_BMXCON.setBMXERRDS; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,8($a0)
end;
procedure TBMX_BMXCON.clearBMXERRDS; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,4($a0)
end;
procedure TBMX_BMXCON.setBMXERRDS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,17,1
  sw      $v1,($a0)
end;
function  TBMX_BMXCON.getBMXERRDS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,17,1
end;
procedure TBMX_BMXCON.setBMXERRDMA; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,8($a0)
end;
procedure TBMX_BMXCON.clearBMXERRDMA; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,4($a0)
end;
procedure TBMX_BMXCON.setBMXERRDMA(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,18,1
  sw      $v1,($a0)
end;
function  TBMX_BMXCON.getBMXERRDMA : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,18,1
end;
procedure TBMX_BMXCON.setBMXERRICD; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,8($a0)
end;
procedure TBMX_BMXCON.clearBMXERRICD; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,4($a0)
end;
procedure TBMX_BMXCON.setBMXERRICD(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,19,1
  sw      $v1,($a0)
end;
function  TBMX_BMXCON.getBMXERRICD : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,19,1
end;
procedure TBMX_BMXCON.setBMXERRIXI; assembler; nostackframe; inline;
asm
  lui     $a1,16
  sw $a1,8($a0)
end;
procedure TBMX_BMXCON.clearBMXERRIXI; assembler; nostackframe; inline;
asm
  lui     $a1,16
  sw $a1,4($a0)
end;
procedure TBMX_BMXCON.setBMXERRIXI(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,20,1
  sw      $v1,($a0)
end;
function  TBMX_BMXCON.getBMXERRIXI : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,20,1
end;
procedure TBMX_BMXCON.setBMXCHEDMA; assembler; nostackframe; inline;
asm
  lui     $a1,1024
  sw $a1,8($a0)
end;
procedure TBMX_BMXCON.clearBMXCHEDMA; assembler; nostackframe; inline;
asm
  lui     $a1,1024
  sw $a1,4($a0)
end;
procedure TBMX_BMXCON.setBMXCHEDMA(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,26,1
  sw      $v1,($a0)
end;
function  TBMX_BMXCON.getBMXCHEDMA : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,26,1
end;
procedure TBMX_BMXCON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TBMX_BMXCON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC_DMACON.setSUSPEND; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TDMAC_DMACON.clearSUSPEND; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TDMAC_DMACON.setSUSPEND(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TDMAC_DMACON.getSUSPEND : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TDMAC_DMACON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TDMAC_DMACON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TDMAC_DMACON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TDMAC_DMACON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TDMAC_DMACON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TDMAC_DMACON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TDMAC_DMACON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TDMAC_DMACON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TDMAC_DMACON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC_DMACON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC_DMASTAT.setDMACH(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,2
  sw      $v1,($a0)
end;
function  TDMAC_DMASTAT.getDMACH : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,2
end;
procedure TDMAC_DMASTAT.setRDWR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TDMAC_DMASTAT.clearRDWR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TDMAC_DMASTAT.setRDWR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TDMAC_DMASTAT.getRDWR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TDMAC_DMASTAT.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC_DMASTAT.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC_DCRCCON.setCRCCH(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,2
  sw      $v1,($a0)
end;
function  TDMAC_DCRCCON.getCRCCH : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,2
end;
procedure TDMAC_DCRCCON.setCRCTYP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC_DCRCCON.clearCRCTYP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC_DCRCCON.setCRCTYP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC_DCRCCON.getCRCTYP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC_DCRCCON.setCRCAPP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC_DCRCCON.clearCRCAPP; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC_DCRCCON.setCRCAPP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC_DCRCCON.getCRCAPP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC_DCRCCON.setCRCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC_DCRCCON.clearCRCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC_DCRCCON.setCRCEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC_DCRCCON.getCRCEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC_DCRCCON.setPLEN(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,4
  sw      $v1,($a0)
end;
function  TDMAC_DCRCCON.getPLEN : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,4
end;
procedure TDMAC_DCRCCON.setBITO; assembler; nostackframe; inline;
asm
  lui     $a1,256
  sw $a1,8($a0)
end;
procedure TDMAC_DCRCCON.clearBITO; assembler; nostackframe; inline;
asm
  lui     $a1,256
  sw $a1,4($a0)
end;
procedure TDMAC_DCRCCON.setBITO(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,24,1
  sw      $v1,($a0)
end;
function  TDMAC_DCRCCON.getBITO : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,24,1
end;
procedure TDMAC_DCRCCON.setWBO; assembler; nostackframe; inline;
asm
  lui     $a1,2048
  sw $a1,8($a0)
end;
procedure TDMAC_DCRCCON.clearWBO; assembler; nostackframe; inline;
asm
  lui     $a1,2048
  sw $a1,4($a0)
end;
procedure TDMAC_DCRCCON.setWBO(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,27,1
  sw      $v1,($a0)
end;
function  TDMAC_DCRCCON.getWBO : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,27,1
end;
procedure TDMAC_DCRCCON.setBYTO(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,28,2
  sw      $v1,($a0)
end;
function  TDMAC_DCRCCON.getBYTO : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,28,2
end;
procedure TDMAC_DCRCCON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC_DCRCCON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC0_DCH0CON.setCHPRI(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,2
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0CON.getCHPRI : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,2
end;
procedure TDMAC0_DCH0CON.setCHEDET; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0CON.clearCHEDET; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0CON.setCHEDET(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0CON.getCHEDET : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TDMAC0_DCH0CON.setCHAEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0CON.clearCHAEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0CON.setCHAEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0CON.getCHAEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TDMAC0_DCH0CON.setCHCHN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0CON.clearCHCHN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0CON.setCHCHN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0CON.getCHCHN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC0_DCH0CON.setCHAED; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0CON.clearCHAED; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0CON.setCHAED(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0CON.getCHAED : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC0_DCH0CON.setCHEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0CON.clearCHEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0CON.setCHEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0CON.getCHEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC0_DCH0CON.setCHCHNS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0CON.clearCHCHNS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0CON.setCHCHNS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0CON.getCHCHNS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TDMAC0_DCH0CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC0_DCH0CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC0_DCH0ECON.setAIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0ECON.clearAIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0ECON.setAIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0ECON.getAIRQEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TDMAC0_DCH0ECON.setSIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0ECON.clearSIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0ECON.setSIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0ECON.getSIRQEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TDMAC0_DCH0ECON.setPATEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0ECON.clearPATEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0ECON.setPATEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0ECON.getPATEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC0_DCH0ECON.setCABORT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0ECON.clearCABORT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0ECON.setCABORT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0ECON.getCABORT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC0_DCH0ECON.setCFORCE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0ECON.clearCFORCE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0ECON.setCFORCE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0ECON.getCFORCE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC0_DCH0ECON.setCHSIRQ(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,8
  lui    $v0,65535
  ori    $v0,$v0,255
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TDMAC0_DCH0ECON.getCHSIRQ : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,8
  ori    $v0,$zero,65280
  and    $a1,$a1,$v0
end;
procedure TDMAC0_DCH0ECON.setCHAIRQ(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,16
  lui    $v0,65280
  ori    $v0,$v0,65535
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TDMAC0_DCH0ECON.getCHAIRQ : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,16
  lui    $v0,255
  and    $a1,$a1,$v0
end;
procedure TDMAC0_DCH0ECON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC0_DCH0ECON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC0_DCH0INT.setCHERIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHERIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHERIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHERIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TDMAC0_DCH0INT.setCHTAIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHTAIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHTAIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHTAIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TDMAC0_DCH0INT.setCHCCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHCCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHCCIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHCCIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TDMAC0_DCH0INT.setCHBCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHBCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHBCIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHBCIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TDMAC0_DCH0INT.setCHDHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHDHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHDHIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHDHIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TDMAC0_DCH0INT.setCHDDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHDDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHDDIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHDDIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC0_DCH0INT.setCHSHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHSHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHSHIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHSHIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC0_DCH0INT.setCHSDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHSDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHSDIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHSDIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC0_DCH0INT.setCHERIE; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHERIE; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHERIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHERIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,1
end;
procedure TDMAC0_DCH0INT.setCHTAIE; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHTAIE; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHTAIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,17,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHTAIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,17,1
end;
procedure TDMAC0_DCH0INT.setCHCCIE; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHCCIE; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHCCIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,18,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHCCIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,18,1
end;
procedure TDMAC0_DCH0INT.setCHBCIE; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHBCIE; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHBCIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,19,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHBCIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,19,1
end;
procedure TDMAC0_DCH0INT.setCHDHIE; assembler; nostackframe; inline;
asm
  lui     $a1,16
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHDHIE; assembler; nostackframe; inline;
asm
  lui     $a1,16
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHDHIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,20,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHDHIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,20,1
end;
procedure TDMAC0_DCH0INT.setCHDDIE; assembler; nostackframe; inline;
asm
  lui     $a1,32
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHDDIE; assembler; nostackframe; inline;
asm
  lui     $a1,32
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHDDIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,21,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHDDIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,21,1
end;
procedure TDMAC0_DCH0INT.setCHSHIE; assembler; nostackframe; inline;
asm
  lui     $a1,64
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHSHIE; assembler; nostackframe; inline;
asm
  lui     $a1,64
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHSHIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,22,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHSHIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,22,1
end;
procedure TDMAC0_DCH0INT.setCHSDIE; assembler; nostackframe; inline;
asm
  lui     $a1,128
  sw $a1,8($a0)
end;
procedure TDMAC0_DCH0INT.clearCHSDIE; assembler; nostackframe; inline;
asm
  lui     $a1,128
  sw $a1,4($a0)
end;
procedure TDMAC0_DCH0INT.setCHSDIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,23,1
  sw      $v1,($a0)
end;
function  TDMAC0_DCH0INT.getCHSDIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,23,1
end;
procedure TDMAC0_DCH0INT.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC0_DCH0INT.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC1_DCH1CON.setCHPRI(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,2
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1CON.getCHPRI : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,2
end;
procedure TDMAC1_DCH1CON.setCHEDET; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1CON.clearCHEDET; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1CON.setCHEDET(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1CON.getCHEDET : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TDMAC1_DCH1CON.setCHAEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1CON.clearCHAEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1CON.setCHAEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1CON.getCHAEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TDMAC1_DCH1CON.setCHCHN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1CON.clearCHCHN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1CON.setCHCHN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1CON.getCHCHN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC1_DCH1CON.setCHAED; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1CON.clearCHAED; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1CON.setCHAED(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1CON.getCHAED : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC1_DCH1CON.setCHEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1CON.clearCHEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1CON.setCHEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1CON.getCHEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC1_DCH1CON.setCHCHNS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1CON.clearCHCHNS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1CON.setCHCHNS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1CON.getCHCHNS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TDMAC1_DCH1CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC1_DCH1CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC1_DCH1ECON.setAIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1ECON.clearAIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1ECON.setAIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1ECON.getAIRQEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TDMAC1_DCH1ECON.setSIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1ECON.clearSIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1ECON.setSIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1ECON.getSIRQEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TDMAC1_DCH1ECON.setPATEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1ECON.clearPATEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1ECON.setPATEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1ECON.getPATEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC1_DCH1ECON.setCABORT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1ECON.clearCABORT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1ECON.setCABORT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1ECON.getCABORT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC1_DCH1ECON.setCFORCE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1ECON.clearCFORCE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1ECON.setCFORCE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1ECON.getCFORCE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC1_DCH1ECON.setCHSIRQ(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,8
  lui    $v0,65535
  ori    $v0,$v0,255
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TDMAC1_DCH1ECON.getCHSIRQ : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,8
  ori    $v0,$zero,65280
  and    $a1,$a1,$v0
end;
procedure TDMAC1_DCH1ECON.setCHAIRQ(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,16
  lui    $v0,65280
  ori    $v0,$v0,65535
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TDMAC1_DCH1ECON.getCHAIRQ : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,16
  lui    $v0,255
  and    $a1,$a1,$v0
end;
procedure TDMAC1_DCH1ECON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC1_DCH1ECON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC1_DCH1INT.setCHERIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHERIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHERIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHERIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TDMAC1_DCH1INT.setCHTAIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHTAIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHTAIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHTAIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TDMAC1_DCH1INT.setCHCCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHCCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHCCIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHCCIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TDMAC1_DCH1INT.setCHBCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHBCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHBCIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHBCIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TDMAC1_DCH1INT.setCHDHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHDHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHDHIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHDHIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TDMAC1_DCH1INT.setCHDDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHDDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHDDIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHDDIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC1_DCH1INT.setCHSHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHSHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHSHIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHSHIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC1_DCH1INT.setCHSDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHSDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHSDIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHSDIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC1_DCH1INT.setCHERIE; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHERIE; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHERIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHERIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,1
end;
procedure TDMAC1_DCH1INT.setCHTAIE; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHTAIE; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHTAIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,17,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHTAIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,17,1
end;
procedure TDMAC1_DCH1INT.setCHCCIE; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHCCIE; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHCCIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,18,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHCCIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,18,1
end;
procedure TDMAC1_DCH1INT.setCHBCIE; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHBCIE; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHBCIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,19,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHBCIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,19,1
end;
procedure TDMAC1_DCH1INT.setCHDHIE; assembler; nostackframe; inline;
asm
  lui     $a1,16
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHDHIE; assembler; nostackframe; inline;
asm
  lui     $a1,16
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHDHIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,20,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHDHIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,20,1
end;
procedure TDMAC1_DCH1INT.setCHDDIE; assembler; nostackframe; inline;
asm
  lui     $a1,32
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHDDIE; assembler; nostackframe; inline;
asm
  lui     $a1,32
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHDDIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,21,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHDDIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,21,1
end;
procedure TDMAC1_DCH1INT.setCHSHIE; assembler; nostackframe; inline;
asm
  lui     $a1,64
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHSHIE; assembler; nostackframe; inline;
asm
  lui     $a1,64
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHSHIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,22,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHSHIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,22,1
end;
procedure TDMAC1_DCH1INT.setCHSDIE; assembler; nostackframe; inline;
asm
  lui     $a1,128
  sw $a1,8($a0)
end;
procedure TDMAC1_DCH1INT.clearCHSDIE; assembler; nostackframe; inline;
asm
  lui     $a1,128
  sw $a1,4($a0)
end;
procedure TDMAC1_DCH1INT.setCHSDIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,23,1
  sw      $v1,($a0)
end;
function  TDMAC1_DCH1INT.getCHSDIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,23,1
end;
procedure TDMAC1_DCH1INT.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC1_DCH1INT.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC2_DCH2CON.setCHPRI(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,2
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2CON.getCHPRI : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,2
end;
procedure TDMAC2_DCH2CON.setCHEDET; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2CON.clearCHEDET; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2CON.setCHEDET(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2CON.getCHEDET : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TDMAC2_DCH2CON.setCHAEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2CON.clearCHAEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2CON.setCHAEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2CON.getCHAEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TDMAC2_DCH2CON.setCHCHN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2CON.clearCHCHN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2CON.setCHCHN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2CON.getCHCHN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC2_DCH2CON.setCHAED; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2CON.clearCHAED; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2CON.setCHAED(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2CON.getCHAED : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC2_DCH2CON.setCHEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2CON.clearCHEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2CON.setCHEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2CON.getCHEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC2_DCH2CON.setCHCHNS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2CON.clearCHCHNS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2CON.setCHCHNS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2CON.getCHCHNS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TDMAC2_DCH2CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC2_DCH2CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC2_DCH2ECON.setAIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2ECON.clearAIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2ECON.setAIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2ECON.getAIRQEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TDMAC2_DCH2ECON.setSIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2ECON.clearSIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2ECON.setSIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2ECON.getSIRQEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TDMAC2_DCH2ECON.setPATEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2ECON.clearPATEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2ECON.setPATEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2ECON.getPATEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC2_DCH2ECON.setCABORT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2ECON.clearCABORT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2ECON.setCABORT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2ECON.getCABORT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC2_DCH2ECON.setCFORCE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2ECON.clearCFORCE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2ECON.setCFORCE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2ECON.getCFORCE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC2_DCH2ECON.setCHSIRQ(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,8
  lui    $v0,65535
  ori    $v0,$v0,255
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TDMAC2_DCH2ECON.getCHSIRQ : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,8
  ori    $v0,$zero,65280
  and    $a1,$a1,$v0
end;
procedure TDMAC2_DCH2ECON.setCHAIRQ(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,16
  lui    $v0,65280
  ori    $v0,$v0,65535
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TDMAC2_DCH2ECON.getCHAIRQ : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,16
  lui    $v0,255
  and    $a1,$a1,$v0
end;
procedure TDMAC2_DCH2ECON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC2_DCH2ECON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC2_DCH2INT.setCHERIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHERIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHERIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHERIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TDMAC2_DCH2INT.setCHTAIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHTAIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHTAIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHTAIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TDMAC2_DCH2INT.setCHCCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHCCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHCCIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHCCIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TDMAC2_DCH2INT.setCHBCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHBCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHBCIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHBCIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TDMAC2_DCH2INT.setCHDHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHDHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHDHIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHDHIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TDMAC2_DCH2INT.setCHDDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHDDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHDDIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHDDIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC2_DCH2INT.setCHSHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHSHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHSHIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHSHIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC2_DCH2INT.setCHSDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHSDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHSDIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHSDIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC2_DCH2INT.setCHERIE; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHERIE; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHERIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHERIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,1
end;
procedure TDMAC2_DCH2INT.setCHTAIE; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHTAIE; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHTAIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,17,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHTAIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,17,1
end;
procedure TDMAC2_DCH2INT.setCHCCIE; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHCCIE; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHCCIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,18,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHCCIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,18,1
end;
procedure TDMAC2_DCH2INT.setCHBCIE; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHBCIE; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHBCIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,19,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHBCIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,19,1
end;
procedure TDMAC2_DCH2INT.setCHDHIE; assembler; nostackframe; inline;
asm
  lui     $a1,16
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHDHIE; assembler; nostackframe; inline;
asm
  lui     $a1,16
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHDHIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,20,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHDHIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,20,1
end;
procedure TDMAC2_DCH2INT.setCHDDIE; assembler; nostackframe; inline;
asm
  lui     $a1,32
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHDDIE; assembler; nostackframe; inline;
asm
  lui     $a1,32
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHDDIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,21,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHDDIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,21,1
end;
procedure TDMAC2_DCH2INT.setCHSHIE; assembler; nostackframe; inline;
asm
  lui     $a1,64
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHSHIE; assembler; nostackframe; inline;
asm
  lui     $a1,64
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHSHIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,22,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHSHIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,22,1
end;
procedure TDMAC2_DCH2INT.setCHSDIE; assembler; nostackframe; inline;
asm
  lui     $a1,128
  sw $a1,8($a0)
end;
procedure TDMAC2_DCH2INT.clearCHSDIE; assembler; nostackframe; inline;
asm
  lui     $a1,128
  sw $a1,4($a0)
end;
procedure TDMAC2_DCH2INT.setCHSDIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,23,1
  sw      $v1,($a0)
end;
function  TDMAC2_DCH2INT.getCHSDIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,23,1
end;
procedure TDMAC2_DCH2INT.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC2_DCH2INT.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC3_DCH3CON.setCHPRI(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,2
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3CON.getCHPRI : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,2
end;
procedure TDMAC3_DCH3CON.setCHEDET; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3CON.clearCHEDET; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3CON.setCHEDET(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3CON.getCHEDET : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TDMAC3_DCH3CON.setCHAEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3CON.clearCHAEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3CON.setCHAEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3CON.getCHAEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TDMAC3_DCH3CON.setCHCHN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3CON.clearCHCHN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3CON.setCHCHN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3CON.getCHCHN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC3_DCH3CON.setCHAED; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3CON.clearCHAED; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3CON.setCHAED(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3CON.getCHAED : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC3_DCH3CON.setCHEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3CON.clearCHEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3CON.setCHEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3CON.getCHEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC3_DCH3CON.setCHCHNS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3CON.clearCHCHNS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3CON.setCHCHNS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3CON.getCHCHNS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TDMAC3_DCH3CON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC3_DCH3CON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC3_DCH3ECON.setAIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3ECON.clearAIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3ECON.setAIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3ECON.getAIRQEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TDMAC3_DCH3ECON.setSIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3ECON.clearSIRQEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3ECON.setSIRQEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3ECON.getSIRQEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TDMAC3_DCH3ECON.setPATEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3ECON.clearPATEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3ECON.setPATEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3ECON.getPATEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC3_DCH3ECON.setCABORT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3ECON.clearCABORT; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3ECON.setCABORT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3ECON.getCABORT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC3_DCH3ECON.setCFORCE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3ECON.clearCFORCE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3ECON.setCFORCE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3ECON.getCFORCE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC3_DCH3ECON.setCHSIRQ(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,8
  lui    $v0,65535
  ori    $v0,$v0,255
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TDMAC3_DCH3ECON.getCHSIRQ : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,8
  ori    $v0,$zero,65280
  and    $a1,$a1,$v0
end;
procedure TDMAC3_DCH3ECON.setCHAIRQ(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,16
  lui    $v0,65280
  ori    $v0,$v0,65535
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TDMAC3_DCH3ECON.getCHAIRQ : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,16
  lui    $v0,255
  and    $a1,$a1,$v0
end;
procedure TDMAC3_DCH3ECON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC3_DCH3ECON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDMAC3_DCH3INT.setCHERIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHERIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHERIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHERIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TDMAC3_DCH3INT.setCHTAIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHTAIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHTAIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHTAIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TDMAC3_DCH3INT.setCHCCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHCCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHCCIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHCCIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TDMAC3_DCH3INT.setCHBCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHBCIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHBCIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHBCIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TDMAC3_DCH3INT.setCHDHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHDHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHDHIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHDHIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TDMAC3_DCH3INT.setCHDDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHDDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHDDIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHDDIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDMAC3_DCH3INT.setCHSHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHSHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHSHIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHSHIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TDMAC3_DCH3INT.setCHSDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHSDIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHSDIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHSDIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDMAC3_DCH3INT.setCHERIE; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHERIE; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHERIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHERIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,1
end;
procedure TDMAC3_DCH3INT.setCHTAIE; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHTAIE; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHTAIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,17,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHTAIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,17,1
end;
procedure TDMAC3_DCH3INT.setCHCCIE; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHCCIE; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHCCIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,18,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHCCIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,18,1
end;
procedure TDMAC3_DCH3INT.setCHBCIE; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHBCIE; assembler; nostackframe; inline;
asm
  lui     $a1,8
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHBCIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,19,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHBCIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,19,1
end;
procedure TDMAC3_DCH3INT.setCHDHIE; assembler; nostackframe; inline;
asm
  lui     $a1,16
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHDHIE; assembler; nostackframe; inline;
asm
  lui     $a1,16
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHDHIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,20,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHDHIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,20,1
end;
procedure TDMAC3_DCH3INT.setCHDDIE; assembler; nostackframe; inline;
asm
  lui     $a1,32
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHDDIE; assembler; nostackframe; inline;
asm
  lui     $a1,32
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHDDIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,21,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHDDIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,21,1
end;
procedure TDMAC3_DCH3INT.setCHSHIE; assembler; nostackframe; inline;
asm
  lui     $a1,64
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHSHIE; assembler; nostackframe; inline;
asm
  lui     $a1,64
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHSHIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,22,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHSHIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,22,1
end;
procedure TDMAC3_DCH3INT.setCHSDIE; assembler; nostackframe; inline;
asm
  lui     $a1,128
  sw $a1,8($a0)
end;
procedure TDMAC3_DCH3INT.clearCHSDIE; assembler; nostackframe; inline;
asm
  lui     $a1,128
  sw $a1,4($a0)
end;
procedure TDMAC3_DCH3INT.setCHSDIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,23,1
  sw      $v1,($a0)
end;
function  TDMAC3_DCH3INT.getCHSDIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,23,1
end;
procedure TDMAC3_DCH3INT.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDMAC3_DCH3INT.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPCACHE_CHECON.setPFMWS(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TPCACHE_CHECON.getPFMWS : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TPCACHE_CHECON.setPREFEN(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,2
  sw      $v1,($a0)
end;
function  TPCACHE_CHECON.getPREFEN : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,2
end;
procedure TPCACHE_CHECON.setDCSZ(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,2
  sw      $v1,($a0)
end;
function  TPCACHE_CHECON.getDCSZ : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,2
end;
procedure TPCACHE_CHECON.setCHECOH; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,8($a0)
end;
procedure TPCACHE_CHECON.clearCHECOH; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,4($a0)
end;
procedure TPCACHE_CHECON.setCHECOH(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,1
  sw      $v1,($a0)
end;
function  TPCACHE_CHECON.getCHECOH : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,1
end;
procedure TPCACHE_CHECON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPCACHE_CHECON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPCACHE_CHETAG.setLTYPE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPCACHE_CHETAG.clearLTYPE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPCACHE_CHETAG.setLTYPE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPCACHE_CHETAG.getLTYPE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPCACHE_CHETAG.setLLOCK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPCACHE_CHETAG.clearLLOCK; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPCACHE_CHETAG.setLLOCK(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPCACHE_CHETAG.getLLOCK : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPCACHE_CHETAG.setLVALID; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPCACHE_CHETAG.clearLVALID; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPCACHE_CHETAG.setLVALID(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPCACHE_CHETAG.getLVALID : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPCACHE_CHETAG.setLTAG(thebits : TBits_20); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,4
  lui    $v0,65280
  ori    $v0,$v0,15
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TPCACHE_CHETAG.getLTAG : TBits_20;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,4
  lui    $v0,255
  ori    $v0,$v0,65520
  and    $a1,$a1,$v0
end;
procedure TPCACHE_CHETAG.setLTAGBOOT; assembler; nostackframe; inline;
asm
  lui     $a1,32768
  sw $a1,8($a0)
end;
procedure TPCACHE_CHETAG.clearLTAGBOOT; assembler; nostackframe; inline;
asm
  lui     $a1,32768
  sw $a1,4($a0)
end;
procedure TPCACHE_CHETAG.setLTAGBOOT(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,31,1
  sw      $v1,($a0)
end;
function  TPCACHE_CHETAG.getLTAGBOOT : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,31,1
end;
procedure TPCACHE_CHETAG.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPCACHE_CHETAG.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TUSB_U1IR.setURSTIF_DETACHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1IR.clearURSTIF_DETACHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1IR.setURSTIF_DETACHIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1IR.getURSTIF_DETACHIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1IR.setUERRIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1IR.clearUERRIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1IR.setUERRIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1IR.getUERRIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1IR.setSOFIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUSB_U1IR.clearSOFIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUSB_U1IR.setSOFIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUSB_U1IR.getSOFIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUSB_U1IR.setTRNIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUSB_U1IR.clearTRNIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUSB_U1IR.setTRNIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUSB_U1IR.getTRNIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUSB_U1IR.setIDLEIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUSB_U1IR.clearIDLEIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUSB_U1IR.setIDLEIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUSB_U1IR.getIDLEIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUSB_U1IR.setRESUMEIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUSB_U1IR.clearRESUMEIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUSB_U1IR.setRESUMEIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUSB_U1IR.getRESUMEIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUSB_U1IR.setATTACHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUSB_U1IR.clearATTACHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUSB_U1IR.setATTACHIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUSB_U1IR.getATTACHIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUSB_U1IR.setSTALLIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUSB_U1IR.clearSTALLIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUSB_U1IR.setSTALLIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUSB_U1IR.getSTALLIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TUSB_U1IR.setDETACHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1IR.clearDETACHIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1IR.setDETACHIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1IR.getDETACHIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1IR.setURSTIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1IR.clearURSTIF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1IR.setURSTIF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1IR.getURSTIF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1IE.setURSTIE_DETACHIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1IE.clearURSTIE_DETACHIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1IE.setURSTIE_DETACHIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1IE.getURSTIE_DETACHIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1IE.setUERRIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1IE.clearUERRIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1IE.setUERRIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1IE.getUERRIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1IE.setSOFIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUSB_U1IE.clearSOFIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUSB_U1IE.setSOFIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUSB_U1IE.getSOFIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUSB_U1IE.setTRNIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUSB_U1IE.clearTRNIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUSB_U1IE.setTRNIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUSB_U1IE.getTRNIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUSB_U1IE.setIDLEIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUSB_U1IE.clearIDLEIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUSB_U1IE.setIDLEIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUSB_U1IE.getIDLEIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUSB_U1IE.setRESUMEIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUSB_U1IE.clearRESUMEIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUSB_U1IE.setRESUMEIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUSB_U1IE.getRESUMEIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUSB_U1IE.setATTACHIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUSB_U1IE.clearATTACHIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUSB_U1IE.setATTACHIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUSB_U1IE.getATTACHIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUSB_U1IE.setSTALLIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUSB_U1IE.clearSTALLIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUSB_U1IE.setSTALLIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUSB_U1IE.getSTALLIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TUSB_U1IE.setDETACHIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1IE.clearDETACHIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1IE.setDETACHIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1IE.getDETACHIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1IE.setURSTIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1IE.clearURSTIE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1IE.setURSTIE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1IE.getURSTIE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1EIR.setPIDEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1EIR.clearPIDEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1EIR.setPIDEF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIR.getPIDEF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1EIR.setCRC5EF_EOFEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1EIR.clearCRC5EF_EOFEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1EIR.setCRC5EF_EOFEF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIR.getCRC5EF_EOFEF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1EIR.setCRC16EF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUSB_U1EIR.clearCRC16EF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUSB_U1EIR.setCRC16EF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIR.getCRC16EF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUSB_U1EIR.setDFN8EF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUSB_U1EIR.clearDFN8EF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUSB_U1EIR.setDFN8EF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIR.getDFN8EF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUSB_U1EIR.setBTOEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUSB_U1EIR.clearBTOEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUSB_U1EIR.setBTOEF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIR.getBTOEF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUSB_U1EIR.setDMAEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUSB_U1EIR.clearDMAEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUSB_U1EIR.setDMAEF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIR.getDMAEF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUSB_U1EIR.setBMXEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUSB_U1EIR.clearBMXEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUSB_U1EIR.setBMXEF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIR.getBMXEF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUSB_U1EIR.setBTSEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUSB_U1EIR.clearBTSEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUSB_U1EIR.setBTSEF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIR.getBTSEF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TUSB_U1EIR.setCRC5EF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1EIR.clearCRC5EF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1EIR.setCRC5EF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIR.getCRC5EF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1EIR.setEOFEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1EIR.clearEOFEF; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1EIR.setEOFEF(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIR.getEOFEF : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1EIE.setPIDEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1EIE.clearPIDEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1EIE.setPIDEE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIE.getPIDEE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1EIE.setCRC5EE_EOFEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1EIE.clearCRC5EE_EOFEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1EIE.setCRC5EE_EOFEE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIE.getCRC5EE_EOFEE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1EIE.setCRC16EE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUSB_U1EIE.clearCRC16EE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUSB_U1EIE.setCRC16EE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIE.getCRC16EE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUSB_U1EIE.setDFN8EE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUSB_U1EIE.clearDFN8EE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUSB_U1EIE.setDFN8EE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIE.getDFN8EE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUSB_U1EIE.setBTOEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUSB_U1EIE.clearBTOEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUSB_U1EIE.setBTOEE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIE.getBTOEE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUSB_U1EIE.setDMAEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUSB_U1EIE.clearDMAEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUSB_U1EIE.setDMAEE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIE.getDMAEE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUSB_U1EIE.setBMXEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUSB_U1EIE.clearBMXEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUSB_U1EIE.setBMXEE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIE.getBMXEE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUSB_U1EIE.setBTSEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUSB_U1EIE.clearBTSEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUSB_U1EIE.setBTSEE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIE.getBTSEE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TUSB_U1EIE.setCRC5EE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1EIE.clearCRC5EE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1EIE.setCRC5EE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIE.getCRC5EE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1EIE.setEOFEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1EIE.clearEOFEE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1EIE.setEOFEE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1EIE.getEOFEE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1STAT.setPPBI; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUSB_U1STAT.clearPPBI; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUSB_U1STAT.setPPBI(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUSB_U1STAT.getPPBI : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUSB_U1STAT.setDIR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUSB_U1STAT.clearDIR; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUSB_U1STAT.setDIR(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUSB_U1STAT.getDIR : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUSB_U1STAT.setENDPT0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUSB_U1STAT.clearENDPT0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUSB_U1STAT.setENDPT0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUSB_U1STAT.getENDPT0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUSB_U1STAT.setENDPT(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,4
  sw      $v1,($a0)
end;
function  TUSB_U1STAT.getENDPT : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,4
end;
procedure TUSB_U1STAT.setENDPT1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUSB_U1STAT.clearENDPT1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUSB_U1STAT.setENDPT1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUSB_U1STAT.getENDPT1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUSB_U1STAT.setENDPT2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUSB_U1STAT.clearENDPT2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUSB_U1STAT.setENDPT2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUSB_U1STAT.getENDPT2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUSB_U1STAT.setENDPT3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUSB_U1STAT.clearENDPT3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUSB_U1STAT.setENDPT3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUSB_U1STAT.getENDPT3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TUSB_U1CON.setUSBEN_SOFEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1CON.clearUSBEN_SOFEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1CON.setUSBEN_SOFEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1CON.getUSBEN_SOFEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1CON.setPPBRST; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1CON.clearPPBRST; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1CON.setPPBRST(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1CON.getPPBRST : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1CON.setRESUME; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUSB_U1CON.clearRESUME; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUSB_U1CON.setRESUME(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUSB_U1CON.getRESUME : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUSB_U1CON.setHOSTEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUSB_U1CON.clearHOSTEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUSB_U1CON.setHOSTEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUSB_U1CON.getHOSTEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUSB_U1CON.setUSBRST; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUSB_U1CON.clearUSBRST; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUSB_U1CON.setUSBRST(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUSB_U1CON.getUSBRST : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUSB_U1CON.setPKTDIS_TOKBUSY; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUSB_U1CON.clearPKTDIS_TOKBUSY; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUSB_U1CON.setPKTDIS_TOKBUSY(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUSB_U1CON.getPKTDIS_TOKBUSY : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUSB_U1CON.setSE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUSB_U1CON.clearSE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUSB_U1CON.setSE0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUSB_U1CON.getSE0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUSB_U1CON.setJSTATE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUSB_U1CON.clearJSTATE; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUSB_U1CON.setJSTATE(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUSB_U1CON.getJSTATE : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TUSB_U1CON.setUSBEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1CON.clearUSBEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1CON.setUSBEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1CON.getUSBEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1CON.setSOFEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1CON.clearSOFEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1CON.setSOFEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1CON.getSOFEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1CON.setPKTDIS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUSB_U1CON.clearPKTDIS; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUSB_U1CON.setPKTDIS(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUSB_U1CON.getPKTDIS : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUSB_U1CON.setTOKBUSY; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUSB_U1CON.clearTOKBUSY; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUSB_U1CON.setTOKBUSY(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUSB_U1CON.getTOKBUSY : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUSB_U1ADDR.setDEVADDR(thebits : TBits_7); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,0
  lui    $v0,65535
  ori    $v0,$v0,65408
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TUSB_U1ADDR.getDEVADDR : TBits_7;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,0
  ori    $v0,$zero,127
  and    $a1,$a1,$v0
end;
procedure TUSB_U1ADDR.setLSPDEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUSB_U1ADDR.clearLSPDEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUSB_U1ADDR.setLSPDEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUSB_U1ADDR.getLSPDEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TUSB_U1ADDR.setDEVADDR0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1ADDR.clearDEVADDR0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1ADDR.setDEVADDR0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1ADDR.getDEVADDR0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1ADDR.setDEVADDR1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1ADDR.clearDEVADDR1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1ADDR.setDEVADDR1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1ADDR.getDEVADDR1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1ADDR.setDEVADDR2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUSB_U1ADDR.clearDEVADDR2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUSB_U1ADDR.setDEVADDR2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUSB_U1ADDR.getDEVADDR2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUSB_U1ADDR.setDEVADDR3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUSB_U1ADDR.clearDEVADDR3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUSB_U1ADDR.setDEVADDR3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUSB_U1ADDR.getDEVADDR3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUSB_U1ADDR.setDEVADDR4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUSB_U1ADDR.clearDEVADDR4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUSB_U1ADDR.setDEVADDR4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUSB_U1ADDR.getDEVADDR4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUSB_U1ADDR.setDEVADDR5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUSB_U1ADDR.clearDEVADDR5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUSB_U1ADDR.setDEVADDR5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUSB_U1ADDR.getDEVADDR5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUSB_U1ADDR.setDEVADDR6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUSB_U1ADDR.clearDEVADDR6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUSB_U1ADDR.setDEVADDR6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUSB_U1ADDR.getDEVADDR6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUSB_U1FRML.setFRML(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,0
  lui    $v0,65535
  ori    $v0,$v0,65280
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TUSB_U1FRML.getFRML : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,0
  ori    $v0,$zero,255
  and    $a1,$a1,$v0
end;
procedure TUSB_U1FRML.setFRM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1FRML.clearFRM0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1FRML.setFRM0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1FRML.getFRM0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1FRML.setFRM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1FRML.clearFRM1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1FRML.setFRM1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1FRML.getFRM1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1FRML.setFRM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUSB_U1FRML.clearFRM2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUSB_U1FRML.setFRM2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUSB_U1FRML.getFRM2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUSB_U1FRML.setFRM3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUSB_U1FRML.clearFRM3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUSB_U1FRML.setFRM3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUSB_U1FRML.getFRM3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUSB_U1FRML.setFRM4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUSB_U1FRML.clearFRM4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUSB_U1FRML.setFRM4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUSB_U1FRML.getFRM4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUSB_U1FRML.setFRM5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUSB_U1FRML.clearFRM5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUSB_U1FRML.setFRM5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUSB_U1FRML.getFRM5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUSB_U1FRML.setFRM6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUSB_U1FRML.clearFRM6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUSB_U1FRML.setFRM6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUSB_U1FRML.getFRM6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUSB_U1FRML.setFRM7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUSB_U1FRML.clearFRM7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUSB_U1FRML.setFRM7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUSB_U1FRML.getFRM7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TUSB_U1FRMH.setFRMH(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TUSB_U1FRMH.getFRMH : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TUSB_U1FRMH.setFRM8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1FRMH.clearFRM8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1FRMH.setFRM8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1FRMH.getFRM8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1FRMH.setFRM9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1FRMH.clearFRM9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1FRMH.setFRM9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1FRMH.getFRM9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1FRMH.setFRM10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUSB_U1FRMH.clearFRM10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUSB_U1FRMH.setFRM10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUSB_U1FRMH.getFRM10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUSB_U1TOK.setEP(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,4
  sw      $v1,($a0)
end;
function  TUSB_U1TOK.getEP : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,4
end;
procedure TUSB_U1TOK.setPID(thebits : TBits_4); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,4
  sw      $v1,($a0)
end;
function  TUSB_U1TOK.getPID : TBits_4;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,4
end;
procedure TUSB_U1TOK.setEP0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TUSB_U1TOK.clearEP0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TUSB_U1TOK.setEP0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TUSB_U1TOK.getEP0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TUSB_U1TOK.setEP1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TUSB_U1TOK.clearEP1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TUSB_U1TOK.setEP1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TUSB_U1TOK.getEP1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TUSB_U1TOK.setEP2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TUSB_U1TOK.clearEP2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TUSB_U1TOK.setEP2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TUSB_U1TOK.getEP2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TUSB_U1TOK.setEP3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TUSB_U1TOK.clearEP3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TUSB_U1TOK.setEP3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TUSB_U1TOK.getEP3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TUSB_U1TOK.setPID0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TUSB_U1TOK.clearPID0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TUSB_U1TOK.setPID0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TUSB_U1TOK.getPID0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TUSB_U1TOK.setPID1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TUSB_U1TOK.clearPID1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TUSB_U1TOK.setPID1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TUSB_U1TOK.getPID1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TUSB_U1TOK.setPID2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TUSB_U1TOK.clearPID2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TUSB_U1TOK.setPID2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TUSB_U1TOK.getPID2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TUSB_U1TOK.setPID3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TUSB_U1TOK.clearPID3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TUSB_U1TOK.setPID3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TUSB_U1TOK.getPID3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTB_TRISB.setTRISB0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTB_TRISB.setTRISB1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTB_TRISB.setTRISB2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTB_TRISB.setTRISB3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTB_TRISB.setTRISB4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTB_TRISB.setTRISB5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTB_TRISB.setTRISB6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTB_TRISB.setTRISB7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTB_TRISB.setTRISB8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTB_TRISB.setTRISB9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTB_TRISB.setTRISB10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPORTB_TRISB.setTRISB11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPORTB_TRISB.setTRISB12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPORTB_TRISB.setTRISB13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPORTB_TRISB.setTRISB14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPORTB_TRISB.setTRISB15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPORTB_TRISB.clearTRISB15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPORTB_TRISB.setTRISB15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPORTB_TRISB.getTRISB15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPORTB_TRISB.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTB_TRISB.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTB_PORTB.setRB0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTB_PORTB.setRB1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTB_PORTB.setRB2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTB_PORTB.setRB3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTB_PORTB.setRB4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTB_PORTB.setRB5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTB_PORTB.setRB6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTB_PORTB.setRB7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTB_PORTB.setRB8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTB_PORTB.setRB9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTB_PORTB.setRB10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPORTB_PORTB.setRB11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPORTB_PORTB.setRB12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPORTB_PORTB.setRB13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPORTB_PORTB.setRB14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPORTB_PORTB.setRB15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPORTB_PORTB.clearRB15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPORTB_PORTB.setRB15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPORTB_PORTB.getRB15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPORTB_PORTB.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTB_PORTB.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTB_LATB.setLATB0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTB_LATB.setLATB1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTB_LATB.setLATB2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTB_LATB.setLATB3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTB_LATB.setLATB4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTB_LATB.setLATB5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTB_LATB.setLATB6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTB_LATB.setLATB7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTB_LATB.setLATB8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTB_LATB.setLATB9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTB_LATB.setLATB10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPORTB_LATB.setLATB11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPORTB_LATB.setLATB12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPORTB_LATB.setLATB13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPORTB_LATB.setLATB14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPORTB_LATB.setLATB15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPORTB_LATB.clearLATB15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPORTB_LATB.setLATB15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPORTB_LATB.getLATB15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPORTB_LATB.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTB_LATB.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTB_ODCB.setODCB0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTB_ODCB.setODCB1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTB_ODCB.setODCB2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTB_ODCB.setODCB3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTB_ODCB.setODCB4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTB_ODCB.setODCB5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTB_ODCB.setODCB6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTB_ODCB.setODCB7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTB_ODCB.setODCB8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTB_ODCB.setODCB9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTB_ODCB.setODCB10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPORTB_ODCB.setODCB11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPORTB_ODCB.setODCB12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPORTB_ODCB.setODCB13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPORTB_ODCB.setODCB14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPORTB_ODCB.setODCB15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPORTB_ODCB.clearODCB15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPORTB_ODCB.setODCB15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPORTB_ODCB.getODCB15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPORTB_ODCB.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTB_ODCB.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTC_TRISC.setTRISC12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPORTC_TRISC.clearTRISC12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPORTC_TRISC.setTRISC12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPORTC_TRISC.getTRISC12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPORTC_TRISC.setTRISC13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPORTC_TRISC.clearTRISC13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPORTC_TRISC.setTRISC13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPORTC_TRISC.getTRISC13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPORTC_TRISC.setTRISC14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPORTC_TRISC.clearTRISC14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPORTC_TRISC.setTRISC14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPORTC_TRISC.getTRISC14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPORTC_TRISC.setTRISC15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPORTC_TRISC.clearTRISC15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPORTC_TRISC.setTRISC15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPORTC_TRISC.getTRISC15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPORTC_TRISC.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTC_TRISC.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTC_PORTC.setRC12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPORTC_PORTC.clearRC12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPORTC_PORTC.setRC12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPORTC_PORTC.getRC12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPORTC_PORTC.setRC13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPORTC_PORTC.clearRC13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPORTC_PORTC.setRC13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPORTC_PORTC.getRC13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPORTC_PORTC.setRC14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPORTC_PORTC.clearRC14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPORTC_PORTC.setRC14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPORTC_PORTC.getRC14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPORTC_PORTC.setRC15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPORTC_PORTC.clearRC15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPORTC_PORTC.setRC15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPORTC_PORTC.getRC15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPORTC_PORTC.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTC_PORTC.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTC_LATC.setLATC12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPORTC_LATC.clearLATC12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPORTC_LATC.setLATC12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPORTC_LATC.getLATC12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPORTC_LATC.setLATC13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPORTC_LATC.clearLATC13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPORTC_LATC.setLATC13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPORTC_LATC.getLATC13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPORTC_LATC.setLATC14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPORTC_LATC.clearLATC14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPORTC_LATC.setLATC14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPORTC_LATC.getLATC14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPORTC_LATC.setLATC15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPORTC_LATC.clearLATC15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPORTC_LATC.setLATC15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPORTC_LATC.getLATC15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPORTC_LATC.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTC_LATC.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTC_ODCC.setODCC12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPORTC_ODCC.clearODCC12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPORTC_ODCC.setODCC12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPORTC_ODCC.getODCC12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPORTC_ODCC.setODCC13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPORTC_ODCC.clearODCC13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPORTC_ODCC.setODCC13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPORTC_ODCC.getODCC13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPORTC_ODCC.setODCC14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPORTC_ODCC.clearODCC14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPORTC_ODCC.setODCC14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPORTC_ODCC.getODCC14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPORTC_ODCC.setODCC15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPORTC_ODCC.clearODCC15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPORTC_ODCC.setODCC15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPORTC_ODCC.getODCC15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPORTC_ODCC.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTC_ODCC.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTD_TRISD.setTRISD0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTD_TRISD.clearTRISD0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTD_TRISD.setTRISD0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTD_TRISD.getTRISD0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTD_TRISD.setTRISD1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTD_TRISD.clearTRISD1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTD_TRISD.setTRISD1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTD_TRISD.getTRISD1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTD_TRISD.setTRISD2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTD_TRISD.clearTRISD2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTD_TRISD.setTRISD2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTD_TRISD.getTRISD2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTD_TRISD.setTRISD3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTD_TRISD.clearTRISD3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTD_TRISD.setTRISD3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTD_TRISD.getTRISD3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTD_TRISD.setTRISD4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTD_TRISD.clearTRISD4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTD_TRISD.setTRISD4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTD_TRISD.getTRISD4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTD_TRISD.setTRISD5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTD_TRISD.clearTRISD5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTD_TRISD.setTRISD5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTD_TRISD.getTRISD5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTD_TRISD.setTRISD6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTD_TRISD.clearTRISD6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTD_TRISD.setTRISD6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTD_TRISD.getTRISD6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTD_TRISD.setTRISD7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTD_TRISD.clearTRISD7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTD_TRISD.setTRISD7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTD_TRISD.getTRISD7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTD_TRISD.setTRISD8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTD_TRISD.clearTRISD8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTD_TRISD.setTRISD8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTD_TRISD.getTRISD8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTD_TRISD.setTRISD9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTD_TRISD.clearTRISD9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTD_TRISD.setTRISD9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTD_TRISD.getTRISD9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTD_TRISD.setTRISD10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPORTD_TRISD.clearTRISD10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPORTD_TRISD.setTRISD10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPORTD_TRISD.getTRISD10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPORTD_TRISD.setTRISD11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPORTD_TRISD.clearTRISD11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPORTD_TRISD.setTRISD11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPORTD_TRISD.getTRISD11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPORTD_TRISD.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTD_TRISD.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTD_PORTD.setRD0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTD_PORTD.clearRD0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTD_PORTD.setRD0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTD_PORTD.getRD0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTD_PORTD.setRD1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTD_PORTD.clearRD1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTD_PORTD.setRD1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTD_PORTD.getRD1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTD_PORTD.setRD2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTD_PORTD.clearRD2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTD_PORTD.setRD2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTD_PORTD.getRD2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTD_PORTD.setRD3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTD_PORTD.clearRD3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTD_PORTD.setRD3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTD_PORTD.getRD3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTD_PORTD.setRD4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTD_PORTD.clearRD4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTD_PORTD.setRD4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTD_PORTD.getRD4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTD_PORTD.setRD5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTD_PORTD.clearRD5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTD_PORTD.setRD5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTD_PORTD.getRD5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTD_PORTD.setRD6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTD_PORTD.clearRD6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTD_PORTD.setRD6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTD_PORTD.getRD6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTD_PORTD.setRD7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTD_PORTD.clearRD7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTD_PORTD.setRD7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTD_PORTD.getRD7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTD_PORTD.setRD8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTD_PORTD.clearRD8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTD_PORTD.setRD8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTD_PORTD.getRD8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTD_PORTD.setRD9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTD_PORTD.clearRD9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTD_PORTD.setRD9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTD_PORTD.getRD9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTD_PORTD.setRD10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPORTD_PORTD.clearRD10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPORTD_PORTD.setRD10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPORTD_PORTD.getRD10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPORTD_PORTD.setRD11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPORTD_PORTD.clearRD11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPORTD_PORTD.setRD11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPORTD_PORTD.getRD11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPORTD_PORTD.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTD_PORTD.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTD_LATD.setLATD0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTD_LATD.clearLATD0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTD_LATD.setLATD0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTD_LATD.getLATD0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTD_LATD.setLATD1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTD_LATD.clearLATD1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTD_LATD.setLATD1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTD_LATD.getLATD1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTD_LATD.setLATD2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTD_LATD.clearLATD2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTD_LATD.setLATD2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTD_LATD.getLATD2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTD_LATD.setLATD3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTD_LATD.clearLATD3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTD_LATD.setLATD3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTD_LATD.getLATD3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTD_LATD.setLATD4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTD_LATD.clearLATD4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTD_LATD.setLATD4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTD_LATD.getLATD4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTD_LATD.setLATD5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTD_LATD.clearLATD5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTD_LATD.setLATD5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTD_LATD.getLATD5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTD_LATD.setLATD6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTD_LATD.clearLATD6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTD_LATD.setLATD6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTD_LATD.getLATD6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTD_LATD.setLATD7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTD_LATD.clearLATD7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTD_LATD.setLATD7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTD_LATD.getLATD7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTD_LATD.setLATD8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTD_LATD.clearLATD8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTD_LATD.setLATD8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTD_LATD.getLATD8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTD_LATD.setLATD9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTD_LATD.clearLATD9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTD_LATD.setLATD9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTD_LATD.getLATD9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTD_LATD.setLATD10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPORTD_LATD.clearLATD10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPORTD_LATD.setLATD10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPORTD_LATD.getLATD10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPORTD_LATD.setLATD11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPORTD_LATD.clearLATD11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPORTD_LATD.setLATD11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPORTD_LATD.getLATD11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPORTD_LATD.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTD_LATD.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTD_ODCD.setODCD0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTD_ODCD.clearODCD0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTD_ODCD.setODCD0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTD_ODCD.getODCD0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTD_ODCD.setODCD1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTD_ODCD.clearODCD1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTD_ODCD.setODCD1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTD_ODCD.getODCD1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTD_ODCD.setODCD2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTD_ODCD.clearODCD2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTD_ODCD.setODCD2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTD_ODCD.getODCD2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTD_ODCD.setODCD3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTD_ODCD.clearODCD3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTD_ODCD.setODCD3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTD_ODCD.getODCD3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTD_ODCD.setODCD4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTD_ODCD.clearODCD4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTD_ODCD.setODCD4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTD_ODCD.getODCD4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTD_ODCD.setODCD5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTD_ODCD.clearODCD5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTD_ODCD.setODCD5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTD_ODCD.getODCD5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTD_ODCD.setODCD6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTD_ODCD.clearODCD6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTD_ODCD.setODCD6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTD_ODCD.getODCD6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTD_ODCD.setODCD7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTD_ODCD.clearODCD7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTD_ODCD.setODCD7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTD_ODCD.getODCD7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTD_ODCD.setODCD8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTD_ODCD.clearODCD8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTD_ODCD.setODCD8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTD_ODCD.getODCD8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTD_ODCD.setODCD9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTD_ODCD.clearODCD9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTD_ODCD.setODCD9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTD_ODCD.getODCD9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTD_ODCD.setODCD10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPORTD_ODCD.clearODCD10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPORTD_ODCD.setODCD10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPORTD_ODCD.getODCD10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPORTD_ODCD.setODCD11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPORTD_ODCD.clearODCD11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPORTD_ODCD.setODCD11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPORTD_ODCD.getODCD11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPORTD_ODCD.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTD_ODCD.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTE_TRISE.setTRISE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTE_TRISE.clearTRISE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTE_TRISE.setTRISE0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTE_TRISE.getTRISE0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTE_TRISE.setTRISE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTE_TRISE.clearTRISE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTE_TRISE.setTRISE1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTE_TRISE.getTRISE1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTE_TRISE.setTRISE2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTE_TRISE.clearTRISE2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTE_TRISE.setTRISE2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTE_TRISE.getTRISE2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTE_TRISE.setTRISE3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTE_TRISE.clearTRISE3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTE_TRISE.setTRISE3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTE_TRISE.getTRISE3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTE_TRISE.setTRISE4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTE_TRISE.clearTRISE4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTE_TRISE.setTRISE4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTE_TRISE.getTRISE4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTE_TRISE.setTRISE5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTE_TRISE.clearTRISE5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTE_TRISE.setTRISE5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTE_TRISE.getTRISE5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTE_TRISE.setTRISE6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTE_TRISE.clearTRISE6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTE_TRISE.setTRISE6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTE_TRISE.getTRISE6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTE_TRISE.setTRISE7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTE_TRISE.clearTRISE7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTE_TRISE.setTRISE7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTE_TRISE.getTRISE7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTE_TRISE.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTE_TRISE.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTE_PORTE.setRE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTE_PORTE.clearRE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTE_PORTE.setRE0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTE_PORTE.getRE0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTE_PORTE.setRE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTE_PORTE.clearRE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTE_PORTE.setRE1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTE_PORTE.getRE1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTE_PORTE.setRE2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTE_PORTE.clearRE2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTE_PORTE.setRE2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTE_PORTE.getRE2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTE_PORTE.setRE3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTE_PORTE.clearRE3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTE_PORTE.setRE3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTE_PORTE.getRE3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTE_PORTE.setRE4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTE_PORTE.clearRE4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTE_PORTE.setRE4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTE_PORTE.getRE4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTE_PORTE.setRE5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTE_PORTE.clearRE5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTE_PORTE.setRE5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTE_PORTE.getRE5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTE_PORTE.setRE6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTE_PORTE.clearRE6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTE_PORTE.setRE6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTE_PORTE.getRE6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTE_PORTE.setRE7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTE_PORTE.clearRE7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTE_PORTE.setRE7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTE_PORTE.getRE7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTE_PORTE.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTE_PORTE.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTE_LATE.setLATE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTE_LATE.clearLATE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTE_LATE.setLATE0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTE_LATE.getLATE0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTE_LATE.setLATE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTE_LATE.clearLATE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTE_LATE.setLATE1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTE_LATE.getLATE1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTE_LATE.setLATE2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTE_LATE.clearLATE2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTE_LATE.setLATE2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTE_LATE.getLATE2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTE_LATE.setLATE3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTE_LATE.clearLATE3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTE_LATE.setLATE3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTE_LATE.getLATE3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTE_LATE.setLATE4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTE_LATE.clearLATE4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTE_LATE.setLATE4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTE_LATE.getLATE4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTE_LATE.setLATE5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTE_LATE.clearLATE5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTE_LATE.setLATE5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTE_LATE.getLATE5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTE_LATE.setLATE6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTE_LATE.clearLATE6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTE_LATE.setLATE6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTE_LATE.getLATE6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTE_LATE.setLATE7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTE_LATE.clearLATE7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTE_LATE.setLATE7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTE_LATE.getLATE7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTE_LATE.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTE_LATE.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTE_ODCE.setODCE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTE_ODCE.clearODCE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTE_ODCE.setODCE0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTE_ODCE.getODCE0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTE_ODCE.setODCE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTE_ODCE.clearODCE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTE_ODCE.setODCE1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTE_ODCE.getODCE1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTE_ODCE.setODCE2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTE_ODCE.clearODCE2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTE_ODCE.setODCE2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTE_ODCE.getODCE2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTE_ODCE.setODCE3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTE_ODCE.clearODCE3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTE_ODCE.setODCE3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTE_ODCE.getODCE3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTE_ODCE.setODCE4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTE_ODCE.clearODCE4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTE_ODCE.setODCE4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTE_ODCE.getODCE4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTE_ODCE.setODCE5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTE_ODCE.clearODCE5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTE_ODCE.setODCE5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTE_ODCE.getODCE5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTE_ODCE.setODCE6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTE_ODCE.clearODCE6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTE_ODCE.setODCE6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTE_ODCE.getODCE6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTE_ODCE.setODCE7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTE_ODCE.clearODCE7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTE_ODCE.setODCE7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTE_ODCE.getODCE7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTE_ODCE.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTE_ODCE.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTF_TRISF.setTRISF0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTF_TRISF.clearTRISF0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTF_TRISF.setTRISF0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTF_TRISF.getTRISF0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTF_TRISF.setTRISF1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTF_TRISF.clearTRISF1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTF_TRISF.setTRISF1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTF_TRISF.getTRISF1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTF_TRISF.setTRISF3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTF_TRISF.clearTRISF3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTF_TRISF.setTRISF3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTF_TRISF.getTRISF3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTF_TRISF.setTRISF4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTF_TRISF.clearTRISF4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTF_TRISF.setTRISF4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTF_TRISF.getTRISF4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTF_TRISF.setTRISF5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTF_TRISF.clearTRISF5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTF_TRISF.setTRISF5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTF_TRISF.getTRISF5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTF_TRISF.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTF_TRISF.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTF_PORTF.setRF0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTF_PORTF.clearRF0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTF_PORTF.setRF0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTF_PORTF.getRF0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTF_PORTF.setRF1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTF_PORTF.clearRF1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTF_PORTF.setRF1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTF_PORTF.getRF1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTF_PORTF.setRF3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTF_PORTF.clearRF3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTF_PORTF.setRF3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTF_PORTF.getRF3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTF_PORTF.setRF4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTF_PORTF.clearRF4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTF_PORTF.setRF4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTF_PORTF.getRF4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTF_PORTF.setRF5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTF_PORTF.clearRF5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTF_PORTF.setRF5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTF_PORTF.getRF5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTF_PORTF.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTF_PORTF.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTF_LATF.setLATF0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTF_LATF.clearLATF0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTF_LATF.setLATF0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTF_LATF.getLATF0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTF_LATF.setLATF1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTF_LATF.clearLATF1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTF_LATF.setLATF1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTF_LATF.getLATF1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTF_LATF.setLATF3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTF_LATF.clearLATF3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTF_LATF.setLATF3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTF_LATF.getLATF3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTF_LATF.setLATF4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTF_LATF.clearLATF4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTF_LATF.setLATF4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTF_LATF.getLATF4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTF_LATF.setLATF5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTF_LATF.clearLATF5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTF_LATF.setLATF5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTF_LATF.getLATF5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTF_LATF.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTF_LATF.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTF_ODCF.setODCF0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTF_ODCF.clearODCF0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTF_ODCF.setODCF0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTF_ODCF.getODCF0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTF_ODCF.setODCF1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTF_ODCF.clearODCF1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTF_ODCF.setODCF1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTF_ODCF.getODCF1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTF_ODCF.setODCF3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTF_ODCF.clearODCF3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTF_ODCF.setODCF3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTF_ODCF.getODCF3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTF_ODCF.setODCF4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTF_ODCF.clearODCF4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTF_ODCF.setODCF4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTF_ODCF.getODCF4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTF_ODCF.setODCF5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTF_ODCF.clearODCF5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTF_ODCF.setODCF5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTF_ODCF.getODCF5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTF_ODCF.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTF_ODCF.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTG_TRISG.setTRISG2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTG_TRISG.clearTRISG2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTG_TRISG.setTRISG2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTG_TRISG.getTRISG2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTG_TRISG.setTRISG3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTG_TRISG.clearTRISG3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTG_TRISG.setTRISG3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTG_TRISG.getTRISG3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTG_TRISG.setTRISG6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTG_TRISG.clearTRISG6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTG_TRISG.setTRISG6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTG_TRISG.getTRISG6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTG_TRISG.setTRISG7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTG_TRISG.clearTRISG7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTG_TRISG.setTRISG7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTG_TRISG.getTRISG7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTG_TRISG.setTRISG8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTG_TRISG.clearTRISG8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTG_TRISG.setTRISG8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTG_TRISG.getTRISG8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTG_TRISG.setTRISG9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTG_TRISG.clearTRISG9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTG_TRISG.setTRISG9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTG_TRISG.getTRISG9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTG_TRISG.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTG_TRISG.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTG_PORTG.setRG2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTG_PORTG.clearRG2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTG_PORTG.setRG2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTG_PORTG.getRG2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTG_PORTG.setRG3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTG_PORTG.clearRG3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTG_PORTG.setRG3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTG_PORTG.getRG3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTG_PORTG.setRG6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTG_PORTG.clearRG6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTG_PORTG.setRG6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTG_PORTG.getRG6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTG_PORTG.setRG7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTG_PORTG.clearRG7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTG_PORTG.setRG7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTG_PORTG.getRG7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTG_PORTG.setRG8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTG_PORTG.clearRG8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTG_PORTG.setRG8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTG_PORTG.getRG8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTG_PORTG.setRG9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTG_PORTG.clearRG9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTG_PORTG.setRG9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTG_PORTG.getRG9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTG_PORTG.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTG_PORTG.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTG_LATG.setLATG2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTG_LATG.clearLATG2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTG_LATG.setLATG2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTG_LATG.getLATG2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTG_LATG.setLATG3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTG_LATG.clearLATG3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTG_LATG.setLATG3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTG_LATG.getLATG3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTG_LATG.setLATG6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTG_LATG.clearLATG6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTG_LATG.setLATG6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTG_LATG.getLATG6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTG_LATG.setLATG7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTG_LATG.clearLATG7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTG_LATG.setLATG7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTG_LATG.getLATG7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTG_LATG.setLATG8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTG_LATG.clearLATG8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTG_LATG.setLATG8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTG_LATG.getLATG8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTG_LATG.setLATG9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTG_LATG.clearLATG9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTG_LATG.setLATG9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTG_LATG.getLATG9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTG_LATG.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTG_LATG.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTG_ODCG.setODCG2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTG_ODCG.clearODCG2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTG_ODCG.setODCG2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTG_ODCG.getODCG2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTG_ODCG.setODCG3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTG_ODCG.clearODCG3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTG_ODCG.setODCG3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTG_ODCG.getODCG3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTG_ODCG.setODCG6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTG_ODCG.clearODCG6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTG_ODCG.setODCG6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTG_ODCG.getODCG6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTG_ODCG.setODCG7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTG_ODCG.clearODCG7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTG_ODCG.setODCG7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTG_ODCG.getODCG7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTG_ODCG.setODCG8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTG_ODCG.clearODCG8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTG_ODCG.setODCG8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTG_ODCG.getODCG8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTG_ODCG.setODCG9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTG_ODCG.clearODCG9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTG_ODCG.setODCG9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTG_ODCG.getODCG9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTG_ODCG.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTG_ODCG.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTG_CNCON.setSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPORTG_CNCON.clearSIDL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPORTG_CNCON.setSIDL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPORTG_CNCON.getSIDL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPORTG_CNCON.setON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPORTG_CNCON.clearON; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPORTG_CNCON.setON(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPORTG_CNCON.getON : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPORTG_CNCON.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTG_CNCON.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTG_CNEN.setCNEN0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTG_CNEN.setCNEN1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTG_CNEN.setCNEN2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTG_CNEN.setCNEN3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTG_CNEN.setCNEN4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTG_CNEN.setCNEN5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTG_CNEN.setCNEN6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTG_CNEN.setCNEN7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTG_CNEN.setCNEN8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTG_CNEN.setCNEN9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTG_CNEN.setCNEN10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPORTG_CNEN.setCNEN11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPORTG_CNEN.setCNEN12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPORTG_CNEN.setCNEN13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPORTG_CNEN.setCNEN14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPORTG_CNEN.setCNEN15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPORTG_CNEN.setCNEN16; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN16; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN16(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN16 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,1
end;
procedure TPORTG_CNEN.setCNEN17; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN17; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN17(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,17,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN17 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,17,1
end;
procedure TPORTG_CNEN.setCNEN18; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,8($a0)
end;
procedure TPORTG_CNEN.clearCNEN18; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,4($a0)
end;
procedure TPORTG_CNEN.setCNEN18(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,18,1
  sw      $v1,($a0)
end;
function  TPORTG_CNEN.getCNEN18 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,18,1
end;
procedure TPORTG_CNEN.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTG_CNEN.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TPORTG_CNPUE.setCNPUE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE0; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE0(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE0 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,1
end;
procedure TPORTG_CNPUE.setCNPUE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE1; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE1(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,1,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE1 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,1,1
end;
procedure TPORTG_CNPUE.setCNPUE2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE2; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE2(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,2,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE2 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,2,1
end;
procedure TPORTG_CNPUE.setCNPUE3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE3; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE3(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE3 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TPORTG_CNPUE.setCNPUE4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE4; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE4(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE4 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,1
end;
procedure TPORTG_CNPUE.setCNPUE5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE5; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE5(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE5 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TPORTG_CNPUE.setCNPUE6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE6; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,64
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE6(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,6,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE6 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,6,1
end;
procedure TPORTG_CNPUE.setCNPUE7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE7; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE7(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE7 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TPORTG_CNPUE.setCNPUE8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE8; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,256
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE8(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE8 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,1
end;
procedure TPORTG_CNPUE.setCNPUE9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE9; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,512
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE9(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,9,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE9 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,9,1
end;
procedure TPORTG_CNPUE.setCNPUE10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE10; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE10(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE10 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TPORTG_CNPUE.setCNPUE11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE11; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,2048
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE11(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,11,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE11 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,11,1
end;
procedure TPORTG_CNPUE.setCNPUE12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE12; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,4096
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE12(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE12 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,1
end;
procedure TPORTG_CNPUE.setCNPUE13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE13; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8192
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE13(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,13,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE13 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,13,1
end;
procedure TPORTG_CNPUE.setCNPUE14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE14; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,16384
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE14(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE14 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,1
end;
procedure TPORTG_CNPUE.setCNPUE15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE15; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE15(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE15 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TPORTG_CNPUE.setCNPUE16; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE16; assembler; nostackframe; inline;
asm
  lui     $a1,1
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE16(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE16 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,1
end;
procedure TPORTG_CNPUE.setCNPUE17; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE17; assembler; nostackframe; inline;
asm
  lui     $a1,2
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE17(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,17,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE17 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,17,1
end;
procedure TPORTG_CNPUE.setCNPUE18; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,8($a0)
end;
procedure TPORTG_CNPUE.clearCNPUE18; assembler; nostackframe; inline;
asm
  lui     $a1,4
  sw $a1,4($a0)
end;
procedure TPORTG_CNPUE.setCNPUE18(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,18,1
  sw      $v1,($a0)
end;
function  TPORTG_CNPUE.getCNPUE18 : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,18,1
end;
procedure TPORTG_CNPUE.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TPORTG_CNPUE.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDEVCFG_DEVCFG3.setUSERID(thebits : TBits_16); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,0
  lui    $v0,65535
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TDEVCFG_DEVCFG3.getUSERID : TBits_16;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,0
  ori    $v0,$zero,65535
  and    $a1,$a1,$v0
end;
procedure TDEVCFG_DEVCFG3.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDEVCFG_DEVCFG3.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDEVCFG_DEVCFG2.setFPLLIDIV(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG2.getFPLLIDIV : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TDEVCFG_DEVCFG2.setFPLLMUL(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,4,3
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG2.getFPLLMUL : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,4,3
end;
procedure TDEVCFG_DEVCFG2.setUPLLIDIV(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,3
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG2.getUPLLIDIV : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,3
end;
procedure TDEVCFG_DEVCFG2.setUPLLEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,8($a0)
end;
procedure TDEVCFG_DEVCFG2.clearUPLLEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32768
  sw $a1,4($a0)
end;
procedure TDEVCFG_DEVCFG2.setUPLLEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,15,1
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG2.getUPLLEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,15,1
end;
procedure TDEVCFG_DEVCFG2.setFPLLODIV(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,3
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG2.getFPLLODIV : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,3
end;
procedure TDEVCFG_DEVCFG2.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDEVCFG_DEVCFG2.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDEVCFG_DEVCFG1.setFNOSC(thebits : TBits_3); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,3
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG1.getFNOSC : TBits_3;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,3
end;
procedure TDEVCFG_DEVCFG1.setFSOSCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,8($a0)
end;
procedure TDEVCFG_DEVCFG1.clearFSOSCEN; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,32
  sw $a1,4($a0)
end;
procedure TDEVCFG_DEVCFG1.setFSOSCEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,5,1
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG1.getFSOSCEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,5,1
end;
procedure TDEVCFG_DEVCFG1.setIESO; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,8($a0)
end;
procedure TDEVCFG_DEVCFG1.clearIESO; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,128
  sw $a1,4($a0)
end;
procedure TDEVCFG_DEVCFG1.setIESO(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,7,1
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG1.getIESO : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,7,1
end;
procedure TDEVCFG_DEVCFG1.setPOSCMOD(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,8,2
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG1.getPOSCMOD : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,8,2
end;
procedure TDEVCFG_DEVCFG1.setOSCIOFNC; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,8($a0)
end;
procedure TDEVCFG_DEVCFG1.clearOSCIOFNC; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,1024
  sw $a1,4($a0)
end;
procedure TDEVCFG_DEVCFG1.setOSCIOFNC(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,10,1
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG1.getOSCIOFNC : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,10,1
end;
procedure TDEVCFG_DEVCFG1.setFPBDIV(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,12,2
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG1.getFPBDIV : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,12,2
end;
procedure TDEVCFG_DEVCFG1.setFCKSM(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,14,2
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG1.getFCKSM : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,14,2
end;
procedure TDEVCFG_DEVCFG1.setWDTPS(thebits : TBits_5); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,16,5
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG1.getWDTPS : TBits_5;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,16,5
end;
procedure TDEVCFG_DEVCFG1.setFWDTEN; assembler; nostackframe; inline;
asm
  lui     $a1,128
  sw $a1,8($a0)
end;
procedure TDEVCFG_DEVCFG1.clearFWDTEN; assembler; nostackframe; inline;
asm
  lui     $a1,128
  sw $a1,4($a0)
end;
procedure TDEVCFG_DEVCFG1.setFWDTEN(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,23,1
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG1.getFWDTEN : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,23,1
end;
procedure TDEVCFG_DEVCFG1.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDEVCFG_DEVCFG1.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
procedure TDEVCFG_DEVCFG0.setDEBUG(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,2
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG0.getDEBUG : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,2
end;
procedure TDEVCFG_DEVCFG0.setICESEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,8($a0)
end;
procedure TDEVCFG_DEVCFG0.clearICESEL; assembler; nostackframe; inline;
asm
  ori     $a1,$zero,8
  sw $a1,4($a0)
end;
procedure TDEVCFG_DEVCFG0.setICESEL(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,3,1
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG0.getICESEL : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,3,1
end;
procedure TDEVCFG_DEVCFG0.setPWP(thebits : TBits_8); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  sll     $a1,$a1,12
  lui    $v0,65520
  ori    $v0,$v0,4095
  and   $v1,$v1,$v0
  or    $a1,$a1,$v0
  sw    $a1,($a0)
end;
function  TDEVCFG_DEVCFG0.getPWP : TBits_8;
asm
  lw      $v1,($a0)
  srl     $a1,$a1,12
  lui    $v0,15
  ori    $v0,$v0,61440
  and    $a1,$a1,$v0
end;
procedure TDEVCFG_DEVCFG0.setBWP; assembler; nostackframe; inline;
asm
  lui     $a1,256
  sw $a1,8($a0)
end;
procedure TDEVCFG_DEVCFG0.clearBWP; assembler; nostackframe; inline;
asm
  lui     $a1,256
  sw $a1,4($a0)
end;
procedure TDEVCFG_DEVCFG0.setBWP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,24,1
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG0.getBWP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,24,1
end;
procedure TDEVCFG_DEVCFG0.setCP; assembler; nostackframe; inline;
asm
  lui     $a1,4096
  sw $a1,8($a0)
end;
procedure TDEVCFG_DEVCFG0.clearCP; assembler; nostackframe; inline;
asm
  lui     $a1,4096
  sw $a1,4($a0)
end;
procedure TDEVCFG_DEVCFG0.setCP(thebits : TBits_1); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,28,1
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG0.getCP : TBits_1;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,28,1
end;
procedure TDEVCFG_DEVCFG0.setFDEBUG(thebits : TBits_2); assembler; nostackframe; inline;
asm
  lw      $v1,($a0)
  ins     $v1,$a1,0,2
  sw      $v1,($a0)
end;
function  TDEVCFG_DEVCFG0.getFDEBUG : TBits_2;
asm
  lw      $v1,($a0)
  ext     $a1,$v1,0,2
end;
procedure TDEVCFG_DEVCFG0.setw(thebits : TBits_32); assembler; nostackframe; inline;
asm
  sw    $a1,($a0)
end;
function  TDEVCFG_DEVCFG0.getw : TBits_32;
asm
  lw      $v1,($a0)
end;
  procedure _CORE_TIMER_VECTOR_interrupt; external name '_CORE_TIMER_VECTOR_interrupt';
  procedure _CORE_SOFTWARE_0_VECTOR_interrupt; external name '_CORE_SOFTWARE_0_VECTOR_interrupt';
  procedure _CORE_SOFTWARE_1_VECTOR_interrupt; external name '_CORE_SOFTWARE_1_VECTOR_interrupt';
  procedure _EXTERNAL_0_VECTOR_interrupt; external name '_EXTERNAL_0_VECTOR_interrupt';
  procedure _TIMER_1_VECTOR_interrupt; external name '_TIMER_1_VECTOR_interrupt';
  procedure _INPUT_CAPTURE_1_VECTOR_interrupt; external name '_INPUT_CAPTURE_1_VECTOR_interrupt';
  procedure _OUTPUT_COMPARE_1_VECTOR_interrupt; external name '_OUTPUT_COMPARE_1_VECTOR_interrupt';
  procedure _EXTERNAL_1_VECTOR_interrupt; external name '_EXTERNAL_1_VECTOR_interrupt';
  procedure _TIMER_2_VECTOR_interrupt; external name '_TIMER_2_VECTOR_interrupt';
  procedure _INPUT_CAPTURE_2_VECTOR_interrupt; external name '_INPUT_CAPTURE_2_VECTOR_interrupt';
  procedure _OUTPUT_COMPARE_2_VECTOR_interrupt; external name '_OUTPUT_COMPARE_2_VECTOR_interrupt';
  procedure _EXTERNAL_2_VECTOR_interrupt; external name '_EXTERNAL_2_VECTOR_interrupt';
  procedure _TIMER_3_VECTOR_interrupt; external name '_TIMER_3_VECTOR_interrupt';
  procedure _INPUT_CAPTURE_3_VECTOR_interrupt; external name '_INPUT_CAPTURE_3_VECTOR_interrupt';
  procedure _OUTPUT_COMPARE_3_VECTOR_interrupt; external name '_OUTPUT_COMPARE_3_VECTOR_interrupt';
  procedure _EXTERNAL_3_VECTOR_interrupt; external name '_EXTERNAL_3_VECTOR_interrupt';
  procedure _TIMER_4_VECTOR_interrupt; external name '_TIMER_4_VECTOR_interrupt';
  procedure _INPUT_CAPTURE_4_VECTOR_interrupt; external name '_INPUT_CAPTURE_4_VECTOR_interrupt';
  procedure _OUTPUT_COMPARE_4_VECTOR_interrupt; external name '_OUTPUT_COMPARE_4_VECTOR_interrupt';
  procedure _EXTERNAL_4_VECTOR_interrupt; external name '_EXTERNAL_4_VECTOR_interrupt';
  procedure _TIMER_5_VECTOR_interrupt; external name '_TIMER_5_VECTOR_interrupt';
  procedure _INPUT_CAPTURE_5_VECTOR_interrupt; external name '_INPUT_CAPTURE_5_VECTOR_interrupt';
  procedure _OUTPUT_COMPARE_5_VECTOR_interrupt; external name '_OUTPUT_COMPARE_5_VECTOR_interrupt';
  procedure _UART_1_VECTOR_interrupt; external name '_UART_1_VECTOR_interrupt';
  procedure _I2C_1_VECTOR_interrupt; external name '_I2C_1_VECTOR_interrupt';
  procedure _CHANGE_NOTICE_VECTOR_interrupt; external name '_CHANGE_NOTICE_VECTOR_interrupt';
  procedure _ADC_VECTOR_interrupt; external name '_ADC_VECTOR_interrupt';
  procedure _PMP_VECTOR_interrupt; external name '_PMP_VECTOR_interrupt';
  procedure _COMPARATOR_1_VECTOR_interrupt; external name '_COMPARATOR_1_VECTOR_interrupt';
  procedure _COMPARATOR_2_VECTOR_interrupt; external name '_COMPARATOR_2_VECTOR_interrupt';
  procedure _SPI_2_VECTOR_interrupt; external name '_SPI_2_VECTOR_interrupt';
  procedure _UART_2_VECTOR_interrupt; external name '_UART_2_VECTOR_interrupt';
  procedure _I2C_2_VECTOR_interrupt; external name '_I2C_2_VECTOR_interrupt';
  procedure _FAIL_SAFE_MONITOR_VECTOR_interrupt; external name '_FAIL_SAFE_MONITOR_VECTOR_interrupt';
  procedure _RTCC_VECTOR_interrupt; external name '_RTCC_VECTOR_interrupt';
  procedure _DMA_0_VECTOR_interrupt; external name '_DMA_0_VECTOR_interrupt';
  procedure _DMA_1_VECTOR_interrupt; external name '_DMA_1_VECTOR_interrupt';
  procedure _DMA_2_VECTOR_interrupt; external name '_DMA_2_VECTOR_interrupt';
  procedure _DMA_3_VECTOR_interrupt; external name '_DMA_3_VECTOR_interrupt';
  procedure _FCE_VECTOR_interrupt; external name '_FCE_VECTOR_interrupt';
  procedure _USB_1_VECTOR_interrupt; external name '_USB_1_VECTOR_interrupt';

  procedure Vectors; assembler; nostackframe;
  label interrupt_vectors;
  asm
    .section ".init.interrupt_vectors,\"ax\",@progbits"
  interrupt_vectors:

    j _CORE_TIMER_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _CORE_SOFTWARE_0_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _CORE_SOFTWARE_1_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _EXTERNAL_0_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _TIMER_1_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _INPUT_CAPTURE_1_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _OUTPUT_COMPARE_1_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _EXTERNAL_1_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _TIMER_2_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _INPUT_CAPTURE_2_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _OUTPUT_COMPARE_2_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _EXTERNAL_2_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _TIMER_3_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _INPUT_CAPTURE_3_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _OUTPUT_COMPARE_3_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _EXTERNAL_3_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _TIMER_4_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _INPUT_CAPTURE_4_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _OUTPUT_COMPARE_4_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _EXTERNAL_4_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _TIMER_5_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _INPUT_CAPTURE_5_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _OUTPUT_COMPARE_5_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _UART_1_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _I2C_1_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _CHANGE_NOTICE_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _ADC_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _PMP_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _COMPARATOR_1_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _COMPARATOR_2_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _SPI_2_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _UART_2_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _I2C_2_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _FAIL_SAFE_MONITOR_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _RTCC_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _DMA_0_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _DMA_1_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _DMA_2_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _DMA_3_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _FCE_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    j _USB_1_VECTOR_interrupt
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    .weak _CORE_TIMER_VECTOR_interrupt
    .weak _CORE_SOFTWARE_0_VECTOR_interrupt
    .weak _CORE_SOFTWARE_1_VECTOR_interrupt
    .weak _EXTERNAL_0_VECTOR_interrupt
    .weak _TIMER_1_VECTOR_interrupt
    .weak _INPUT_CAPTURE_1_VECTOR_interrupt
    .weak _OUTPUT_COMPARE_1_VECTOR_interrupt
    .weak _EXTERNAL_1_VECTOR_interrupt
    .weak _TIMER_2_VECTOR_interrupt
    .weak _INPUT_CAPTURE_2_VECTOR_interrupt
    .weak _OUTPUT_COMPARE_2_VECTOR_interrupt
    .weak _EXTERNAL_2_VECTOR_interrupt
    .weak _TIMER_3_VECTOR_interrupt
    .weak _INPUT_CAPTURE_3_VECTOR_interrupt
    .weak _OUTPUT_COMPARE_3_VECTOR_interrupt
    .weak _EXTERNAL_3_VECTOR_interrupt
    .weak _TIMER_4_VECTOR_interrupt
    .weak _INPUT_CAPTURE_4_VECTOR_interrupt
    .weak _OUTPUT_COMPARE_4_VECTOR_interrupt
    .weak _EXTERNAL_4_VECTOR_interrupt
    .weak _TIMER_5_VECTOR_interrupt
    .weak _INPUT_CAPTURE_5_VECTOR_interrupt
    .weak _OUTPUT_COMPARE_5_VECTOR_interrupt
    .weak _UART_1_VECTOR_interrupt
    .weak _I2C_1_VECTOR_interrupt
    .weak _CHANGE_NOTICE_VECTOR_interrupt
    .weak _ADC_VECTOR_interrupt
    .weak _PMP_VECTOR_interrupt
    .weak _COMPARATOR_1_VECTOR_interrupt
    .weak _COMPARATOR_2_VECTOR_interrupt
    .weak _SPI_2_VECTOR_interrupt
    .weak _UART_2_VECTOR_interrupt
    .weak _I2C_2_VECTOR_interrupt
    .weak _FAIL_SAFE_MONITOR_VECTOR_interrupt
    .weak _RTCC_VECTOR_interrupt
    .weak _DMA_0_VECTOR_interrupt
    .weak _DMA_1_VECTOR_interrupt
    .weak _DMA_2_VECTOR_interrupt
    .weak _DMA_3_VECTOR_interrupt
    .weak _FCE_VECTOR_interrupt
    .weak _USB_1_VECTOR_interrupt

    .text
  end;
end.
