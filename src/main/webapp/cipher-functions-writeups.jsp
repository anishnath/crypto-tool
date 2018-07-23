<h2 id="aesadvancedencryptionstandard"><strong>AES</strong> Advanced Encryption Standard</h2>

<blockquote>
<pre><code>Key sizes   128, 192 or 256 bits
Block sizes 128 bits
Rounds      10, 12 or 14
</code></pre>
</blockquote>

<p><strong>Ciphers</strong> </p>

<blockquote>
<pre><code>AES/CBC/NOPADDING  AES 128 bit Encryption in CBC Mode (Counter Block Mode ) PKCS5 Padding
AES/CBC/PKCS5PADDING   AES 128 bit Encryption in ECB Mode (Electronic Code Book Mode ) No Padding
AES/ECB/NOPADDING-  AES 128 bit Encryption in ECB Mode (Electronic Code Book Mode ) No Padding
AES/ECB/PKCS5PADDING  AES 128 bit Encryption in ECB Mode (Electronic Code Book Mode ) PKCS5PADDING
AES_128/CBC/NOPADDING  AES 128 bit Encryption in CBC Mode (Counter Block Mode ) No Padding, CBC requires Initial Vector
AES_128/CFB/NOPADDING  AES 128 bit Encryption in CBC Mode (Cipher Feedback Mode ) No Padding, CBC requires Initial Vector
AES_128/ECB/NOPADDING  ECB Mode
AES_128/GCM/NOPADDING  GCM Mode
AES_128/OFB/NOPADDING  AES Encryption in Output Feedback Mode
AES_192/CBC/NOPADDING  AES 192 bit encryption in CBC Mode
AES_192/CFB/NOPADDING  AES 192 bit encryption in CFB Mode
AES_192/ECB/NOPADDING  AES 192 bit encryption in ECB Mode, ECB Mode doesn’t require any Initial Vector
AES_192/GCM/NOPADDING  AES 192 bit encryption in GCM mode
AES_192/OFB/NOPADDING  AES 192 bit encryption in ofb mode
AES_256/CBC/NOPADDING  AES 256 bit encryption in cbc mode
AES_256/CFB/NOPADDING  Aes 256 bit encryption in CFB mode
AES_256/ECB/NOPADDING  Aes 256 bit encryption in ECB mode
AES_256/GCM/NOPADDING   Aes 256 bit encryption in GCM mode
AES_256/OFB/NOPADDING  Aes 256 bit encryption in OFB mode
</code></pre>
</blockquote>

<h2 id="aria">ARIA</h2>

<blockquote>
	<p>Derived from      AES
		Key sizes   128, 192, or 256 bits Block sizes
		128 bits</p>
</blockquote>

<h2 id="blowfish">BLOWFISH</h2>

<blockquote>
	<p>Designers   Bruce Schneier
		First published   1993
		Successors  Twofish
		Key sizes   32–448 bits Block sizes 64 bits Structure <br />
		Feistel network Rounds      16</p>
</blockquote>

<h2 id="camellia">CAMELLIA</h2>

<blockquote>
<pre><code>Designers   Mitsubishi Electric, NTT
First published   2000
Derived from      E2, MISTY1
Certification     CRYPTREC, NESSIE
</code></pre>
</blockquote>

<p><strong>Cipher detail</strong></p>

<blockquote>
<pre><code>Key sizes   128, 192 or 256 bits
Block sizes 128 bits
Structure   Feistel network
Rounds      18 or 24
</code></pre>
</blockquote>

<h2 id="cast5cast6">CAST5/ CAST6</h2>

<blockquote>
<pre><code>Designers   Carlisle Adams and Stafford Tavares
First published   1996
Successors  CAST-256
Cipher detail
Key sizes   40 to 128 bits
Block sizes 64 bits
Structure   Feistel network
Rounds      12 or 16
</code></pre>
</blockquote>

<h2 id="chacha">CHACHA</h2>

<blockquote>
<pre><code>Designers   Daniel J. Bernstein
First published   2007
Related to  Rumba20, ChaCha
Certification     eSTREAM portfolio
Cipher detail
Key sizes   256 bits
State size  512 bits
Structure   ARX
Rounds      20
</code></pre>
</blockquote>

<h2 id="des">DES</h2>

<blockquote>
<pre><code>Designers   IBM
First published   1975
Derived from      Lucifer
Successors  Triple DES, G-DES, DES-X, LOKI89, ICE
Cipher detail
Key sizes   56 bits (+8 parity bits)
Block sizes 64 bits
Structure   Balanced Feistel network
Rounds      16
</code></pre>
</blockquote>

<p><strong>Ciphers</strong> </p>

<blockquote>
<pre><code>DES/CBC/NOPADDING
DES/CBC/PKCS5PADDING
DES/ECB/NOPADDING
DES/ECB/PKCS5PADDING
</code></pre>
</blockquote>

<h2 id="desede">DESEDE</h2>

<blockquote>
<pre><code>First published   1998 (ANS X9.52)
Derived from      DES
Cipher detail
Key sizes   168, 112 or 56 bits (keying option 1, 2, 3 respectively)
Block sizes 64 bits
Structure   Feistel network
Rounds      48 DES-equivalent rounds
</code></pre>
</blockquote>

<p><strong>Ciphers</strong></p>

<pre><code>DESEDE/CBC/NOPADDING
DESEDE/CBC/PKCS5PADDING
DESEDE/ECB/NOPADDING
DESEDE/ECB/PKCS5PADDING
</code></pre>

<h2 id="idea">IDEA</h2>

<blockquote>
<pre><code>Designers   Xuejia Lai and James Massey
Derived from      PES
Successors  MMB, MESH, Akelarre,
IDEA NXT (FOX)
</code></pre>
</blockquote>

<p><strong>Cipher detail</strong></p>

<blockquote>
<pre><code>Key sizes   128 bits
Block sizes 64 bits
Structure   Lai-Massey scheme
Rounds      8.5
</code></pre>
</blockquote>

<h2 id="rc2">RC2</h2>

<blockquote>
	<p>Designers   Ron Rivest (RSA Security) designed in 1987)</p>
</blockquote>

<p><strong>Cipher detail</strong></p>

<blockquote>
<pre><code>Key sizes   40–2048 bits
State size  2064 bits (1684 effective)
Rounds      1
</code></pre>
</blockquote>

<h2 id="rc5">RC5</h2>

<blockquote>
<pre><code>Designers   Ron Rivest
First published   1994
Successors  RC6, Akelarre
</code></pre>

	<p><strong>Cipher detail</strong></p>

<pre><code>Key sizes   0 to 2040 bits (128 suggested)
Block sizes 32, 64 or 128 bits (64 suggested)
Structure   Feistel-like network
Rounds      1-255
</code></pre>
</blockquote>

<p><strong>RC6</strong></p>

<h2 id="rijndael">RIJNDAEL</h2>

<p>The Advanced Encryption Standard (AES), also called Rijndael</p>

<h2 id="skipjack">SKIPJACK</h2>

<blockquote>
<pre><code>Designers   NSA
First published   1998 (declassified)
</code></pre>
</blockquote>

<p><strong>Cipher detail</strong></p>

<blockquote>
<pre><code>Key sizes   80 bits
Block sizes 64 bits
Structure   unbalanced Feistel network\[1\]
Rounds      32
</code></pre>
</blockquote>

<h2 id="threefish">THREEFISH</h2>

<p>Designers   Bruce Schneier, Niels Ferguson, Stefan Lucks, Doug Whiting, Mihir Bellare, Tadayoshi Kohno, Jon Callas, Jesse Walker</p>

<blockquote>
<pre><code>First published   2008
Related to  Blowfish, Twofish
</code></pre>
</blockquote>

<p><strong>Cipher detail</strong></p>

<blockquote>
<pre><code>Key sizes   256, 512 or 1024 bits (key size is equal to block size)
Block sizes 256, 512 or 1024 bits
Rounds      72 (80 for 1024-bit block size)
</code></pre>
</blockquote>

<h2 id="twofish">TWOFISH</h2>

<blockquote>
<pre><code>Designers   Bruce Schneier
First published   1998
Derived from      Blowfish, SAFER, Square
Related to  Threefish
Certification     AES finalist
</code></pre>
</blockquote>

<p><strong>Cipher detail</strong></p>

<blockquote>
<pre><code>Key sizes   128, 192 or 256 bits
Block sizes 128 bits
Structure   Feistel network
Rounds      16
</code></pre>
</blockquote>

<p><strong>More Ciphers</strong> There are Alot </p>

<ul>
	<li>PBEWITHSHA1ANDRC4_128  PBKDF1 and PBKDF2 (Password-Based Key Derivation Function 2)</li>

	<li>PBEWITHSHA1ANDRC4_40  PBKDF1 and PBKDF2 (Password-Based Key Derivation Function 2)</li>

	<li>VMPC </li>

	<li>VMPC-KSA3 </li>

	<li>XTEA </li>

	<li>GCM Galois/Counter Mode </li>

	<li>GOST28147  </li>

	<li>GRAIN128  </li>

	<li>GRAINV1 </li>

	<li>HC128 </li>

	<li>HC256 </li>

	<li>NOEKEON  </li>

	<li>SALSA20  </li>

	<li>SEED  </li>

	<li>SHACAL-2  </li>

	<li>SM4  </li>

	<li>SERPENT  </li>

	<li>SHACAL2  </li>

	<li>TEA  </li>

	<li>TNEPRES </li>
</ul>
<hr>