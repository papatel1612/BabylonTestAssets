echo off
REM Create a series of compressed textures versions of the file name passed in. Skips files which already
REM exist, since script can be very long running.
REM arg 1: file
REM arg 2: file without extension
REM arg 3: Y when need alpha, else N
REM arg 4: Q when best image required, else D for developer quality

REM -i specifies the input file passed as the first arg (full path) dos use 1%
REM -pot + indicates force power of 2
REM -m indicates to generate mipmaps
REM -f is the format, variable type (UBN unsigned byte normalized), colorspace
REM -q indicates how much time to spend, varies by encoding type
REM -o specifies output file name, uses arg without extension adds -family.ktx
REM - - - - - - - - - - - - - - - ASTC  - - - - - - - - - - - - - - - 
echo working with %1
REM all ASTC formats have alpha
IF EXIST %2-astc.ktx GOTO PVRTC

SET quality=astcveryfast
if %4 == 'Q' SET quality=astcexhaustive
echo compressing...
PVRTexToolCLI.exe -i %1 -flip y -pot + -m -f ASTC_8x8,UBN,lRGB -q %quality% -shh -o %2-astc.ktx >junk.txt
echo Saved texture to %2-astc.ktx

REM - - - - - - - - - - - - - - -  DXT  - - - - - - - - - - - - - - -
:DXT
IF EXIST %2-dxt.ktx GOTO ETC1

SET format=BC1
if %3 == 'Y' SET format=BC2

PVRTexToolCLI.exe -i %1 -flip y -pot + -m -f %format%,UBN,lRGB -o %2-dxt.ktx
