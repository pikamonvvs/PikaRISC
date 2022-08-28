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
Ubuntu 20.04
iverilog & vvp 11.0 (stable)
gtkwave 3.3.104
make 4.2.1
```

위의 도구들이 설치되어있지 않다면, 아래의 명령어로 설치할 수 있습니다.

```
sudo apt install -y iverilog gtkwave make
```

## 4. 컴파일 및 시뮬레이션 방법

컴파일은 iverilog를 이용하였으며, 시뮬레이션은 vvp와 gtkwave를 이용하였습니다.

먼저 test.hex 파일을 프로젝트의 root 디렉토리로 가져옵니다.

```
# test.hex 가져오기
mv test.hex PikaRISC
cd PikaRISC
```

그리고 아래의 방법으로 컴파일 및 시뮬레이션할 수 있습니다.

```
# 테스트벤치 빌드 및 시뮬레이션
iverilog -I sources/ -DFOR_TEST -o test.vvp testbench.v
vvp test.vvp
gtkwave test.vcd
```

또는 프로젝트 내에 Makefile을 만들어 두었으므로, make를 통해 동일한 명령을 수행할 수 있습니다.

```
make
```

(※주의: gtkwave는 반드시 GUI 환경에서 실행되어야 합니다.)

## 5. 예제

LLVM 예제에서 생성한 test.hex 파일을 이용하여 RISC를 테스트해보겠습니다.

test.hex는 아래와 같습니다.

```
> cat test.hex

0c00b82f 00000004 08e00094 6300400c
04e04094 00e00094 04e00090 00000084
0c00808d 04e00090 00e00094 04e00090
00e04090 00400080 0c00c08c 04e00090
00e00094 04e00090 00e04090 00000480
0c00c08c 04e00090 00e00094 04e00090
00e04090 00000480 0c00008d 04e00090
00e00094 04e00090 00e04090 00400080
0c00008d 04e00090 00e00094 04e00090
00e04090 00400080 0c00408c 04e00090
00e00094 00000004 0c00b827 0000009c
```

이를 프로젝트의 root 디렉토리에 넣은 후 make를 실행합니다.

```
make
```

그러면 자동으로 gtkwave가 실행되며, 시뮬레이션 결과를 볼 수 있습니다.

![PikaRISC Simulation Result](https://github.com/pikamonvvs/PikaProject/blob/master/resources/Simulation%20Result.png)

## 6. Future works

1. CALL, RET 동작 미구현

아직 CALL, RET 명령어의 동작이 구현되지 않았습니다. 가장 합리적인 구현 방법을 구상하고 있습니다.

2. FPGA 합성 가능 여부 미확인

본 코드가 실제 FPGA 위에서 합성 가능한지 검증되지 않았습니다. 추후 Xilinx Vivado 툴을 이용하여 합성 및 Program 예정입니다.

