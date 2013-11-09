# n-queens problem

* date: 2013-11-09
* author:
  * name: ka
  * Homepage: http://kaosfield.net
  * Twitter: [@ka_](https://twitter.com/ka_)
  * GitHub: [kaosf](https://github.com/kaosf)


## N クイーン問題の続き

### 前回のおさらい

* N クイーン問題とは何かを知った
* チェスの基本的なルールを覚えた (**重要**)
* Clojure で解いてみる方針だった
* [N-queens problem - Rosetta Code](http://rosettacode.org/wiki/N-queens_problem#Clojure) に正解例があった
* Clojure のコードを関数ごとに分けて考えていた


## 関数一覧

* `extend`
* `extends?`

この 2 つを理解出来れば良い


## 文章を読む

```txt
This produces all solutions by essentially a backtracking algorithm.
The heart is the extends? function, which takes a partial solution for
the first k<size columns and sees if the solution can be extended by
adding a queen at row n of column k+1. The extend function takes a
list of all partial solutions for k columns and produces a list of all
partial solutions for k+1 columns. The final list solutions is
calculated by starting with the list of 0-column solutions (obviously
this is the list [ [] ], and iterates extend for size times.
```


## backtracking 法とは

おおまかに言うと

1. 一つずつ試していく
2. ダメになった時点で大丈夫だった時点まで戻る
3. 次を試す
4. 最後まで行けたものが解である


## extends? 関数

この実装の心臓部は `extends?` 関数である

k (k < size) 列の部分解を受け取り  
それに n を付け加えても大丈夫かどうかを調べる


## extends? 関数

### 部分解

k (k < size) 列，size 行のチェス盤で  
それぞれの列に 1 つのクイーンを配置し  
どの 2 つもお互いに効き合っていないもの


## extends? 関数

### 部分解の例

size が 4 とする

k = 0

```clj
[]
```

k = 1

```clj
[1] [2] [3] [4]
```

k = 2

```clj
[1 3] [1 4] [2 4] [3 1] [4 1] [4 2]
```


## extend? 関数

"n を付け加えても…" とはどういう意味か

n は 1 ≦ n ≦ size を満たす整数である

n を部分解の最後に追加しても新たな部分解になるか？  
ということ


## extends? 関数

拡張可能・不可能を判断してみる

size = 4 として以下の部分解を考える

```clj
[2 4]
```

n = 1 を付け加える: OK

```clj
[2 4 1]
```

n = 2 を付け加える: NG

```clj
[2 4 2]
```

n = 3 を付け加える: NG

```clj
[2 4 3]
```


## extends? 関数

図で見てみる

```clj
[2 4] -> [2 4 1]
```

```txt
+-+-+    +-+-+-+
| | | -> | | |Q|
+-+-+    +-+-+-+
|Q| |    |Q| | |
+-+-+    +-+-+-+
| | |    | | | |
+-+-+    +-+-+-+
| |Q|    | |Q| |
+-+-+    +-+-+-+
```

OK


## extends? 関数

図で見てみる

```clj
[2 4] -> [2 4 2]
```

```txt
+-+-+    +-+-+-+
| | | -> | | | |
+-+-+    +-+-+-+
|Q| |    |Q| |Q|
+-+-+    +-+-+-+
| | |    | | | |
+-+-+    +-+-+-+
| |Q|    | |Q| |
+-+-+    +-+-+-+
```

NG


## extends? 関数

図で見てみる

```clj
[2 4] -> [2 4 3]
```

```txt
+-+-+    +-+-+-+
| | | -> | | | |
+-+-+    +-+-+-+
|Q| |    |Q| | |
+-+-+    +-+-+-+
| | |    | | |Q|
+-+-+    +-+-+-+
| |Q|    | |Q| |
+-+-+    +-+-+-+
```

NG



## extends? 関数

実装

```clj
(defn extends? [v n]
  (let [k (count v)]
    (not-any? true?
      (for [i (range k) :let [vi (v i)]]
        (or
          (= vi n)  ;check for shared row
          (= (- k i) (Math/abs (- n vi)))))))) ;check for shared diagonal
```

v が部分解  
n が拡張する列のクイーンの位置


## extends? 関数

前回勘違いしていたこと

```txt
+-+-+    +-+-+-+
| | | -> | | | |
+-+-+    +-+-+-+
| | |    | | | |
+-+-+    +-+-+-+
         | | | |
         +-+-+-+
```

こういう形の拡張ではない


## extend 関数

部分解の集合から拡張された部分解の集合を得る関数


## extend 関数

```clj
[[1] [2] [3] [4]]
```

から

```clj
[[1 3] [1 4] [2 4] [3 1] [4 1] [4 2]]
```

を得る


## extend 関数

extend 関数を 8 回適用すれば 8-Queens の解が無事得られる
