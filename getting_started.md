% Frovedis: NEC **fr**amework **o**f **ve**ctorized and **dis**tributed data analytics

# 1. Introduction

This directory contains Frovedis, which is high-performance middleware
for data analytics. It is written in C++ and utilizes MPI for
communication between the servers.

It provides

- Spark-like API for distributed processing
- Matrix library using above API
- Machine learning algorithm library
- Dataframe for preprocessing
- Spark/Python interface for easy utilization

Our primary target architecture is SX-Aurora TSUBASA, which is NEC's
vector computer; these libraries are carefully written to support
vectorization. However, they are just standard C++ programs and can
run efficiently on other architectures like x86.

X86 version is in ./x86 directory; VE version is in ./ve.
We recommend to use x86 version for development.
(In addition, Spark/Python interface depends on binaries in x86 build.)

The machine learning algorithm library performs really well on sparse
datasets, especially on SX-Aurora TSUBASA. In the case of logistic
regression, it performed 10x faster on x86, and 100x faster on
SX-Aurora TSUBASA, compared to Spark on x86.

In addition, it provides Spark/Python interface that is mostly
compatible with Spark MLlib and Python scikit-learn. If you are using
these libraries, you can easily utilize it. In the case of SX-Aurora
TSUBASA, Spark/Python runs on x86 side and the middleware runs on VE
(Vector Engine); therefore, users can enjoy the high-performance
without noticing the hardware details.

# 2. C++ interface

Essentially, it is just an MPI library. 
We recommend to start from x86 version.
To use x86 version, please setup your environment variables by

    $ source ./x86/bin/x86env.sh

The PATH includes MPI environment that is installed in ./x86/opt/openmpi.

Tutorial is in ./x86/doc/tutorial/tutorial.[md,pdf]. 
The directory also contains small programs that are explained in the
tutorial. You can copy the source files into your home directory and
compile them by yourself. The Makefile and Makefile.in.x86 contains
configurations for compilation, like compilation options, path to
include files, libraries, etc. (Include files are in ./x86/include, and
libraries to link are in ./x86/lib.) You can re-use it for your own
programs.

The small programs in the tutorial directory looks like this:

    #include <frovedis.hpp>
    
    int two_times(int i) {return i*2;}
    
    int main(int argc, char* argv[]){
      frovedis::use_frovedis use(argc, argv);
      
      std::vector<int> v;
      for(size_t i = 1; i <= 8; i++) v.push_back(i);
      auto d1 = frovedis::make_dvector_scatter(v);
      auto d2 = d1.map(two_times);
      auto r = d2.gather();
      for(auto i: r) std::cout << i << std::endl;
    }

This program creates distributed vector from std::vector, and doubles
its elements in a distribited way; then gathers to std::vector again.
As you can see, you can write distributed program quite easily and
consicely compared to MPI program.

In addition, there are also sample programs in ./samples directory.
You can also use them as reference when you write your own programs.
The compiled binaries of them are in ./bin directory.

As for the APIs, please refer to the manual.pdf in ./[x86,ve]/doc/manual. 
(They are the same.) Manual path is also set by x86env.sh.
You can use man command like "man dvector". 

To use VE, first please setup your environment variables for the cross
comilers and MPI, which is out of scope of this document.
(Usually, add /opt/nec/ve/bin to your PATH, and source necmpivars.sh
in the MPI installed directory.) Please do not source x86env.sh above. 

After that, you can do similarly as x86 version; use Makefile and
Makefile.in.ve in ./ve/doc/tutorial/src directory, etc.
Please note that command line option of mpirun is different from x86
version:  You need to add extra "-x" before the binary.

    $ mpirun -np 4 -x ./tut

To use multiple VEs, you need different options. Please refer to the
MPI manual.


# 3. Spark/Python interafce

You can utilize the predefined functionalities from Spark/Python,
which includes machine learning algorithms and matrix operations.
This is implemented as a server; the server accepts RPC (remote
procedure call) to provide the above functionalities from Spark or
Python. The server can run on both x86 and VE.

To run the server, the network should be configured properly.
Please check if

    $ hostname -i

returns the correct IP address.

To use x86 version of the server, first source ./x86/bin/x86env.sh
It also includes various environment variables for Spark and Python.
Spark and Scala are already installed in ./x86/opt.

Then, ./foreign_if_demo/[spark,python] includes the demo.
Please copy these directories into your home directory (since it
creates files). The scripts ./foreign_if_demo/spark/run_demo.sh and 
./foreign_if_demo/python/run_demo.sh run demos. As for Spark, compiled
jar files are used; as for Python, Python scripts are used.
The server is invoked from the script and shutdown at the end of the
program. 

You can modify the Spark programs and Python scripts; there is a
Makefile to build jar file from Spark/Scala programs.

As for Spark, you can also utilize Zeppelin, which is a kind of
notebook tool that can be used from Web browser.

    $ ./x86/opt/zeppelin/extract_zeppelin.sh somewhere_in_your_homedir

This command downloads and extracts Zeppelin into the specified directory.
You can start Zeppelin by calling

    $ extracted_path/bin/zeppelin-daemon.sh start 

Then you can access Zeppelin at default port 8080.
(You can change the port number by creating conf/zeppelin-env.sh and 
include definition of environment variable "export ZEPPELIN_PORT=18080". 
Please refer to the Zeppelin's manual). 

The extaction script above also copies json files that contain sample
notes: Normal_Spark.json and Spark_with_Frovedis.json. You can import
these notes by the Web UI (If you are running the browser on a
different machine, you need to copy the json files to the machine). 
It contains recommendation demo using singular value decomposition in
the case of normal Spark and using Frovedis server. The data used in
this demo is in ./data directory, which is created from MovieLens data
(F. Maxwell Harper and Joseph A. Konstan. 2015. The MovieLens Datasets:
History and Context. ACM Transactions on Interactive Intelligent
Systems (TiiS) 5, 4, Article 19 (December 2015)).

To use a server that runs on VE, please source ./ve/bin/veenv.sh.
You also need to setup your MPI environment, like mpirun.
The difference from ./x86/bin/x86env.sh is that the environment
variable FROVEDIS_SERVER is changed, which is used in the above demo
programs including Zeppelin. Other than that, the procedure is the
same as the x86 server case.

# 5. License

License of this software is in ./[x86,ve]/licenses/LICENSE file. 

This software includes third party software. Licenses of these
software are in ./[x86, ve]/licenses/third_party. 
For convenience, ./[x86,ve]/include/frovedis/core/ inclues a
few third party files whose license is Boost Software License (shown
in the header of the files).
