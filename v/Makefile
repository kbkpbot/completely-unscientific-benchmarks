SRC_FILES = $(wildcard *.v)
TARGETS = $(SRC_FILES:main-%.v=%)

ALL_BINARIES = $(TARGETS:%=main-%)

.PHONY: all
all: $(ALL_BINARIES)

%: %.v
	v -prod -o $@ $<
	strip -s $@

RUN_ALL_BINARIES = $(TARGETS:%=run-%)

.PHONY: $(RUN_ALL_BINARIES)
$(RUN_ALL_BINARIES): run-%: main-%
	./$<

.PHONY: run
run: $(RUN_ALL_BINARIES)

.PHONY: clean
clean:
	rm $(ALL_BINARIES)
