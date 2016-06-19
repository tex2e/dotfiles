
.PHONY: test

TESTERS := $(wildcard ./test/*_test.sh)

test:
	@$(foreach tester, $(TESTERS), \
		$(tester); \
	)
