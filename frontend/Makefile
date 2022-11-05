.PHONY: all install lint run test

all: install run

install:
	flutter pub get

lint:
	flutter analyze

run:
	@# export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
	flutter run -d chrome --web-port 55542

test:
	flutter test --coverage
