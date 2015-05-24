LungSoundStudy App
==========

The LungSoundStudy app is based on (forked from) mPower App, one of the first five apps built using [ResearchKit](https://github.com/researchkit/ResearchKit).

The goal of this app is to build lung sound dataset for researchers to study and analyze the dataset.


Building the App
================

###Requirements

* Xcode 6.3
* iOS 8.3 SDK

###Getting the source

First, check out the source, including all the dependencies:

```
git clone --recurse-submodules https://github.com/hptran/LungSoundStudy.git
```

###Building it

Open the project, `LungSoundStudy.xcodeproj`, and build and run.


Other notes from mPower
===========================

Several survey instruments used in the shipping app have been
removed from the open source version because they are not free
to use:

* [PDQ8](http://isis-innovation.com/outcome-measures/parkinsons-disease-questionnaire-pdq-39-pdq-8/) (Parkinson's disease questionnaire)
* [MDS-UPDRS](http://www.movementdisorders.org/MDS/Education/Rating-Scales.htm) (Parkinson's disease rating scale)

The shipping app also uses OpenSSL to add extra data protection, which
has not been included in the published version of the AppCore
project. See the [AppCore repository](https://github.com/researchkit/AppCore) for more details.

Data upload to [Bridge](http://sagebase.org/bridge/) has been disabled, the logos of the institutions have been removed, and
the consent material has been marked as an example.

License
=======

The source in the LungSoundStudy repository is made available under the
following license unless another license is explicitly identified:

```
Copyright (c) 2015, Sage Bionetworks, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this 
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors 
may be used to endorse or promote products derived from this software without 
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

```

