<CsoundSynthesizer>
<CsOptions>
-n
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 256
nchnls = 2
0dbfs  = 1

#include "AudioToPolar.csp/AudioToPolar.udo"
#include "ChangeFileExtension.csp/ChangeFileExtension.udo"

#ifndef FILE_PATH
    #define FILE_PATH #""#
#endif

instr AudioToPV5File

    Spath = "$FILE_PATH"
    iFFTSize init 1024
    iHop init iFFTSize/4
    ki init 0
    puts Spath, 1

    iFileLength filelen Spath

    iFileLength = iFileLength * sr
    kFrameLength = int((iFileLength - iFFTSize) / iHop)

    aSig diskin2 Spath

    kframe, kmagnitudes[], kfrequencies[] AudioToPolar aSig, iFFTSize, iHop
    SoutputPath ChangeFileExtension Spath, "pv5"
    hdf5write SoutputPath, kmagnitudes, kfrequencies

    if (ki == kFrameLength) then
        event "e", 0, 0
    endif

    ki += 1

    ktime timeinstk

endin

schedule("AudioToPV5File", 0, -1)

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
