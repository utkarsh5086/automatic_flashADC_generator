from subprocess import Popen,run
import subprocess


#Popen(["ngspice","-r","rawfile.raw","-b","/Users/utkarshsharma/sscs_2024/strongARM_us/lvs/flash_w_rdac_eval_plotting.sp"],cwd="simulation").wait()

Popen(["ngspice","-r","rawfile.raw","-b","/simulation/flash_w_rdac_eval_3b.sp"],cwd="simulation").wait()
