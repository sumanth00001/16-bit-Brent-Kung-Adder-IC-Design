
# 16-bit-Kogge-Stone Adder IC Design
Kogge-Stone Adder is one of the parallel prefix type carry look ahead adder. Peter M. Kogge and Harold S. Stone constructed the KSA, which they have been published in year 1973. The Kogge-Stone prefix adder is the fastest adder. In VLSI implementations, the KS(Kogge-Stone) adder performs the best. With minimal fan-outs, the Kogge-Stone Adder has a large area. The Kogge-Stone Adder is commonly as a PPA that executes fastest logical additive operation. Because it exhibits the least amount of delay among the other architectures, the Kogge-Stone Adder is used for wide adders. At the each stage, the KS tree accomplishes fan-out of 2 at stages and log2 N stages. This is an effect of expense of having to route multiple lengthy wires between these stages. This tree also contains those additional PG cells, though which may not have such an effect on the area if an structure has been used to delay growth which tends to increase with an log N. Each vertical stage in figure generates bits for propagate and generation. The final step produces the generate bits, after in which they are XOR’ed with the input’s are initially propagated to create the sum bits.

![Kogge-Stone](https://user-images.githubusercontent.com/113964084/200914307-75676712-e01d-4ae3-a13c-8192eec3d988.png)


This adder have been designed using the Verilog Hardware Description Language using Xilinx.ISE.Navigator.10.1 software, and modelsim.6.5e was used for all simulations. It is analysed and compared to determine how the proposed adders perform. The implementation code for 16-bit Kogge-Stone Adder was developed in this proposed architecture, and delay and area values have
been observed . The correlation of adders is the major element in the trade-off between these various topologies. These simulated output wave forms and RTL schematics have been generated and synthesis is carried out by chipscope. OpenLANE and Caravel are used with Skywater 130nm PDK. OpenLANE flow consists of multiple itersative stages where we obtain GDSII form RTL netlist. This chip design acquired from OpenLANE is used in caravel to place it on an SoC and design is hardened by placing our HDL code in user_project_wrapper and user_proj_example in caravel folders.

Open Source Digital ASIC Design requires three open-source components:  
- **RTL Designs** = github.com, librecores.org, opencores.org
- **EDA Tools** = OpenROAD, OpenLANE,QFlow  
- **PDK** = Google + Skywater 130nm Production PDK

**PDK (Process Design Kit)** = A set of data files and documents which serves as the interface between the designer and the fab. This includes cell libraries, IO libraries, design rules (DRC, LVS, etc.)

### Simplified RTL to GDSII Flow:
- **Sythesis** = The RTL is converted into a gate level netlist made up of components of standard cell libary. 
- **Floor Planning/ Power Planning** = Plan silicon area and create robust power distribution network. The power network usually uses the upper metal layer which are thicker than lower layer and thus lower resistance. This lowers the IR drop problem
 - **Placement** = There are two steps, first is global placement which is the general optimal positons for cells and might not be legal. Next is detailed placement which is the actual legal placements of the cells.
 - **Clock tree synthesis** = clock distribution is usually a tree (H-tree, X-tree ... )
 - **Routing** = Use horizontal and vertical wires to connect cells together. The router uses PDK information (thickness, pitch, width,vias) for each metal layer to do the routing. The Sky130 defines 6 routing layers. It doe global routing and detailed routing.
 - **Verification before sign-off** = Involves physical verification like DRC and LVS and timing verification. Design Rule Checking or DRC ensures final layout honors all design rules and Layout versus Schematic or LVS ensures final layout matches the gate level netlist from synthesis phase. Timing verification ensures timing constraints are met.  

 The final layout is in GDSII file format.
 
 [OpenLane](https://github.com/sumanth00001/OpenLane) = An open-source ASIC development flow reference. It consists of multiple open-source tools needed for the whole RTL to GDSII flow. This is tuned epecially for Sky130 PDK. It also works for OSU 130nm. It is recommended to read the [OpenLANE documentation](https://openlane.readthedocs.io/en/latest/)  before moving forward.
  ![openlane_flowchart](https://user-images.githubusercontent.com/113964084/200916377-a4ee9397-4502-416f-9393-4b8ae0423a3a.png)













# Caravel User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

| :exclamation: Important Note            |
|-----------------------------------------|

## Please fill in your project documentation in this README.md file 

Refer to [README](docs/source/index.rst#section-quickstart) for a quickstart of how to use caravel_user_project

Refer to [README](docs/source/index.rst) for this sample project documentation. 
