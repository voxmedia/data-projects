# Consumer Expenditure Survey

Data process converts csv into nested json files for article on [consumer spending](http://www.vox.com/personal-finance/2015/9/15/9261771/us-consumer-spending-2014).


## About the data

The Bureau of Labor Statistics released data on annual expenditures for 2014. The original data separated by income range is duplicated here in `original.xlsx`. That spreadsheet contains categories that appear to be nested with visual formatting (that is, not with spaces but with internal cell margins with a spreadsheet application). 

I manually added parent categories to each of the items in the original spreadsheet to produce `categories.csv`. Running `jsonify.rb` will create nested json files for use in interactive graphics.


## How to run

```sh
$ ruby jsonify.rb
```


## License

The dataset on consumer expenditures is in the public domain. Otherwise, the script that creates the json files is licensed as follows:

Copyright (c) 2015, Vox Media, Inc. All rights reserved.

BSD license

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


## Contact

Email soo@vox.com if you have questions.