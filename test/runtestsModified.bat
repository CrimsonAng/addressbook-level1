@ECHO OFF

REM change current directory to the location of this script
pushd %~dp0

REM create bin directory if it doesn't exist
if not exist ..\bin mkdir ..\bin

REM compile the code into the bin folder
javac  ..\src\seedu\addressbook\Addressbook.java -d ..\bin
IF ERRORLEVEL 1 (
    echo ********** BUILD FAILURE ********** 
    REM return to previous directory
    popd
    exit /b 1
)
REM no error here, errorlevel == 0

REM (invalid) no parent directory, invalid filename with no extension
java -classpath ..\bin seedu.addressbook.AddressBook " " < NUL > actualModified.txt
REM (invalid) invalid parent directory that does not exist, valid filename
java -classpath ..\bin seedu.addressbook.AddressBook "directoryThatDoesNotExist/valid.filename" < NUL >> actualModified.txt
REM (invalid) no parent directory, invalid filename with dot on first character
java -classpath ..\bin seedu.addressbook.AddressBook ".noFilename" < NUL >> actualModified.txt
REM (invalid) valid parent directory, non regular file
if not exist data\notRegularFile.txt mkdir data\notRegularFile.txt
java -classpath ..\bin seedu.addressbook.AddressBook "data/notRegularFile.txt" < NUL >> actualModified.txt
REM (valid) valid parent directory, valid filename with extension.
copy /y NUL data\valid.filename
java -classpath ..\bin seedu.addressbook.AddressBook "data/valid.filename" < exitinput.txt >> actualModified.txt
REM run the program, feed commands from input.txt file and redirect the output to the actual.txt
java -classpath ..\bin seedu.addressbook.AddressBook < inputModified.txt >> actualModified.txt

REM compare the output to the expected output
FC actualModified.txt expectedModified.txt

REM return to previous directory
popd
