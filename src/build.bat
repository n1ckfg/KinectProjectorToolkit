@echo off

cd %cd%
javac -cp "C:\Program Files\processing\core\library\core.jar" KinectProjectorToolkit\*.java
move /y KinectProjectorToolkit\*.class build\KinectProjectorToolkit\
cd build
jar cvfm ..\KinectProjectorToolkit.jar manifest.txt KinectProjectorToolkit\*.class

@pause