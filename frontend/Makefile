.PHONY: all install lint run test

all: install run

install:
	flutter pub get

lint:
	flutter analyze

format:
	flutter format --line-length 88 --fix

run:
	@# export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
	flutter run -d chrome --web-port 55542

test:
	flutter test --coverage
