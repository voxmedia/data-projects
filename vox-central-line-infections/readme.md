# Central line infection data

A messy but reproducible data workflow for a 
[map on central line infections](//www.vox.com/a/infections-hospitals-map) accompanying a 
[feature article on medical harm](//www.vox.com/2015/7/9/8905959/medical-harm-infection-prevention). 

It uses shell scripts, [csvkit](//csvkit.readthedocs.org), and a couple Python 
scripts because the shell stuff got too out of hand. It's not at all optimized 
for performance. It's only been tested on an early 2015 MacBook Pro. But it's 
heavily commented. Although I did a lot of the early work in MySQL, I used csvkit 
for these scripts because I think it's more accessible than MySQL.

Inspired by [NPR's visual team](//github.com/nprapps/leso).

Your final rendered table should look like [`hospitals_clabsi.csv`](hospitals_clabsi.csv).

## How to run

```bash
$ ./process.sh
```
The process script creates a timestamped directory, clones scripts into it, and 
runs the scripts. (Cloning allowed me to test edits before making adjustments to 
the master scripts.) 

There are some other commands in the individual scripts themselves that you can 
comment or un-comment based on what you want. You can read the scripts to find 
out what they do.


## License

The datasets on hospitals and healthcare associated infections are in the public domain as part of the U.S. government's open datasets at medicare.gov. Otherwise, the data workflow scripts and resulting central line infection dataset (and its accompanying footnotes list) are licensed as follows:

Copyright (c) 2015, Vox Media, Inc. All rights reserved.

BSD license

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


## Contact

If you do use the central lines dataset, we'd appreciate [an email](mailto:editorialapps@voxmedia.com) or a link back, but it's not required.

Email [soo@vox.com](mailto:soo@vox.com) if you have questions about the dataset.