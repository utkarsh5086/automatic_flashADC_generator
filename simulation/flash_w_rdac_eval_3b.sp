** Utkarsh Sharma 2024


.include /Users/utkarshsharma/sscs_2024/strongARM_us/lvs/parameters.txt
.temp 25



** global params
.param VDD = 1.8
.param vcm = 0.9
.param delay = 2n
.param vin = 0.4
.param vref = 0.5
.param fclk = 100MEG
*62.5MEG
.param Tr = '0.05/fclk'

** Add sources
Vsupply VDD GND 1.8

**Import SKY130 lib
.lib /usr/bin/miniconda3/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt

**Import subcircuit
**.include /Users/utkarshsharma/sscs_2024/strongARM_us/lvs/mystrongARM_lvsmag.spice
.include /Users/utkarshsharma/sscs_2024/strongARM_us/flash_w_rdac_pex.spice
.include /Users/utkarshsharma/sscs_2024/strongARM_us/rdac_pex.spice

*V1 VINP GND 'vcm+vin/2'
*V2 VINM GND 'vcm-vin/2'
V5 VCM GND 'vcm'



*V6 VINP VCM 'vin/2'
*Vs1 VINP VCM SIN(0 0.85 4.6875MEG 0 0)
V7 VINP VCM PWL(0 -0.9 320NS 0.9)
E0 VINM VCM VINP VCM -1.0

*R6 VCM GND R=1MEG
*R7 VINP GND R=1MEG
*R8 VINM GND R=1MEG

Vc1 CLK GND PULSE(1.8 0 '100p+delay' 'Tr' 'Tr' '1/(2*Fclk)' '1/Fclk')
Vc2 CLK1 GND PULSE(0 1.8 100p 'Tr' 'Tr' '1/(2*Fclk)' '1/Fclk')
Vc3 CLK1_B GND PULSE(1.8 0 100p 'Tr' 'Tr' '1/(2*Fclk)' '1/Fclk')
Vc4 CLK2 GND PULSE(1.8 0 100p 'Tr' 'Tr' '1/(2*Fclk)' '1/Fclk')
Vc5 CLK2_B GND PULSE(0 1.8 100p 'Tr' 'Tr' '1/(2*Fclk)' '1/Fclk')

**Import netlist
XDAC1 Vp1 Vp2 Vp3 Vp4 Vp5 Vp6 Vp7 GND VDD rdac 
XDAC2 Vm1 Vm2 Vm3 Vm4 Vm5 Vm6 Vm7 GND VDD rdac 

**XDUT OUTM_6 OUTP_6 OUTM_5 OUTP_5 OUTM_4 OUTP_4 OUTM_3 OUTP_3 OUTM_2 OUTP_2 OUTM_1 OUTP_1 OUTM_0 OUTP_0 CLK CLK2_B CLK2 CLK1_B CLK1 VCM VCOMP_M_2 VCOMP_P_2 Vm1 Vp3 VCOMP_M_1 VCOMP_P_1 Vm2 Vp2 VCOMP_M_0 VCOMP_P_0 Vm3 Vp1 VINM VINP GND VDD flash_w_rdac

XDUT  OUTM_6 OUTP_6 OUTM_5 OUTP_5 OUTM_4 OUTP_4 OUTM_3 OUTP_3 OUTM_2 OUTP_2 OUTM_1 OUTP_1 OUTM_0 OUTP_0 CLK CLK2_B CLK2 CLK1_B CLK1 VCM VCOMP_M_6 VCOMP_P_6
+ Vm1 Vp7 VCOMP_M_5 VCOMP_P_5 Vm2 Vp6 VCOMP_M_4 VCOMP_P_4 Vm3
+ Vp5 VCOMP_M_3 VCOMP_P_3 Vm4 Vp4 VCOMP_M_2 VCOMP_P_2 Vm5 Vp3
+ VCOMP_M_1 VCOMP_P_1 Vm6 Vp2 VCOMP_M_0 VCOMP_P_0 Vm7 Vp1 VINM VINP
+ GND VDD flash_w_rdac

*C0 OUTM_2 GND C=Cload
*C1 OUTP_2 GND C=Cload
*C2 OUTM_1 GND C=Cload
*C3 OUTP_1 GND C=Cload
*C4 OUTM_0 GND C=Cload
*C5 OUTP_0 GND C=Cload

*C6 VCOMP_P_0 GND C=0.1f
*C7 VCOMP_M_0 GND C=0.1f
*C8 VCOMP_P_1 GND C=0.1f
*C9 VCOMP_M_1 GND C=0.1f
*C10 VCOMP_P_2 GND C=0.1f
*C11 VCOMP_M_2 GND C=0.1f

*E1 VODIFF GND VOP VOM 1.0
*E2 VCOMP GND VCOMP_P VCOMP_M 1.0
E3 VREF1 GND Vm1 Vp3 1.0
E4 VIDIFF GND VINP VINM 1.0
E5 VREF2 GND Vm2 Vp2 1.0
E6 VREF3 GND Vm3 Vp1 1.0

**simulation
**.option method=gear reltol=1e-6 interp
**.tran '1/Fclk' '64/Fclk'
**.tran '1/Fclk'  320NS
.save OUTM_2 OUTP_2 OUTM_1 OUTP_1 OUTM_0 OUTP_0 CLK CLK2_B CLK2 CLK1_B CLK1 VCM VCOMP_M_2 VCOMP_P_2 Vm1 Vp3 VCOMP_M_1 VCOMP_P_1 Vm2 Vp2 VCOMP_M_0 VCOMP_P_0 Vm3 Vp1 VINM VINP GND VDD VREF1 VREF2 VREF3 VIDIFF @Vsupply


.control
**set wr_singlescale
**set wr_vecnames
**run
tran '1/Fclk'  320NS
wrdata output.txt OUTM_0/1.8 + OUTM_1/1.8 + OUTM_2/1.8 + OUTM_3/1.8 + OUTM_4/1.8 + OUTM_5/1.8 + OUTM_6/1.8
.endc



.GLOBAL GND 
.GLOBAL VDD

.END 
