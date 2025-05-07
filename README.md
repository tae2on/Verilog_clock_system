## ⏰ VHDL Clock System

### 프로젝트 개요
본 프로젝트는 Verilog를 활용해 디지털 시계 시스템을 구현한 것으로, DIP 스위치를 이용해 다양한 모드를 전환할 수 있도록 설계되었습니다.<br> 
기본 시계 기능 외에 각 팀원이 맡은 개인별 커스텀 기능(시간 설정, 알람 송신, UART 수신 등)을 추가로 개발하여 확장성을 높였습니다.<br>
Quartus 훈련 키트를 활용해 실제 하드웨어상에서 동작을 검증하였으며, 이 과정을 통해 하드웨어 기술 언어(HDL)의 이해도를 높이고 회로 설계 능력을 향상시키는 것을 목표로 합니다.

### 개발 환경
- 언어: Verilog HDL
- 개발 툴: Intel Quartus Prime
- 테스트 환경: FPGA 개발 키트 (훈련 키트)
- 시리얼 통신: CoolTerm (UART 터미널)

### 블록선도
![블록선도](https://github.com/tae2on/Verilog_clock_system/blob/main/img/%EB%B8%94%EB%A1%9D%EC%84%A0%EB%8F%84.png?raw=true)


### 팀원소개 
| [강명현](https://github.com/rkdaudgus94) (팀장)| [이혜선](https://github.com/ssun0402) | [황태언](https://github.com/tae2on) |
| :---: | :---: | :---: |
| [<img src="https://github.com/rkdaudgus94.png" width="100px">](https://github.com/rkdaudgus94) | [<img src="https://github.com/ssun0402.png" width="100px">](https://github.com/ssun0402) | [<img src="https://github.com/tae2on.png" width="100px">](https://github.com/tae2on) |
| <div align="left">**공통 기능**<br>• 디지털 시계 표시 기능 구현<br>• DIP 스위치 기반 모드 전환<br><br>**개인 기능**<br>• DIP 3번: UART 수신 기능으로 모드 변경</div> | <div align="left">**공통 기능**<br>• 디지털 시계 표시 기능 구현<br>• DIP 스위치 기반 모드 전환<br><br>**개인 기능**<br>• DIP 2번: 알람 발생 시 UART 송신 기능</div> | <div align="left">**공통 기능**<br>• 디지털 시계 표시 기능 구현<br>• DIP 스위치 기반 모드 전환<br><br>**개인 기능**<br>• DIP 1번: 날짜·요일·시간 설정 기능</div> |
