# PikaRISC

Verilog HDL을 이용하여 PIKA 아키텍처에 정의된 명령어를 수행하는 프로세서를 구현하였습니다. 

## 1. Specification

프로세서 스펙은 아래와 같습니다.

```
* 32-bit CPU
* 5-Stage Single-Cycle Processor
* IMEM Size: 1KB
* DMEM Size: 1KB
```

## 2. 전체 구조

PIKA 프로세서의 전체적인 구조는 아래와 같습니다.

![PIKA Structural Diagram](https://github.com/pikamonvvs/PikaProject/blob/master/resources/Structural%20Diagram.png)

Fetch, Decode, Execute, Memory, Writeback으로 총 5단계로 구분되어 있습니다. PC와 CPSR은 레지스터 파일 안에 들어있으며, 레지스터 파일은 프로세서 안에 내장되어 있습니다. 반면에 명령어 메모리와 데이터 메모리는 프로세서 바깥으로 빼놓았습니다. 이는 테스트벤치를 통해 디버깅을 쉽게 하기 위함입니다.

다섯 단계로 나뉘어져 있지만 아쉽게도 파이프라인은 아닙니다. 성능보다는 단순한 구조를 중점으로 두었기 때문에 싱글 사이클 모델로 설계하였습니다.

## 3. 컴파일 및 시뮬레이션 환경

아래 환경에서 컴파일 및 시뮬레이션 하였습니다.

```
Windows 10
iverilog 12.0 (devel)
gtkwave 3.3.108
```

(※주의: gtkwave는 반드시 GUI 환경에서 실행되어야 합니다.)

## 4. 컴파일 및 시뮬레이션 방법

컴파일은 iverilog를 이용하였으며, 시뮬레이션은 vvp와 gtkwave를 이용하였습니다.

아래의 방법으로 컴파일 및 시뮬레이션할 수 있습니다. testbench.v

```
iverilog -I sources/ -DFOR_TEST -o test.vvp testbench.v
vvp test.vvp
gtkwave test.vcd
```
또는 프로젝트 내에 Makefile을 만들어 두었으므로, make를 통해 동일한 명령을 수행할 수 있습니다.

```
make
```

## 5. Future works

1. CALL, RET 동작 미구현

아직 CALL, RET 명령어의 동작이 구현되지 않았습니다. 가장 합리적인 구현 방법을 구상하고 있습니다.

2. FPGA 합성 가능 여부 미확인

본 코드가 실제 FPGA 위에서 합성 가능한지 검증되지 않았습니다. 추후 Xilinx Vivado 툴을 이용하여 합성 및 Program 예정입니다.

