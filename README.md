# Unityのおしごと本 サンプル
C93で配布をした「Unityのおしごと本」の一章のサンプルになります。
本には一部コードしか記載がありませんでしたので、こちらのサンプルコードと一緒に見て頂ければと思います。
サンプルは **Unity_2017_3** で作成をしています。

![表紙](https://github.com/NaokiYokota/C93_unity_book_effect_sample/blob/Image/Image/c93.png "表紙")

配布サークルについてはこちらを確認下さい。

サークル:[albatrus](https://webcatalog-free.circle.ms/Circle/13601235) (ログインが必要です)

## 内容
三つのシェーダーと一つのエフェクトのサンプルになります。
機能単体のプレハブになりますので、どういったパラメーターやコードで作成されているかの参考にしていただければと思います。

### フローマップシェーダー - FlowMapShader
ParticleSystemのCustomDataを利用をして、テクスチャを動かすタイミングを調整しています。
フローマップはShaderを作るよりも、専用のテクスチャを作るのがとても大変です。
簡単に作成できる方法があれば是非教えてください。

![フローマップ](https://github.com/NaokiYokota/C93_unity_book_effect_sample/blob/Image/Image/flowmapChange.png "フローマップ")


### 削りシェーダー - SharpenParticle
実装は単純で、Mainで利用しているテクスチャのアルファに、削りテクスチャのパラメータを利用している。
Timeを使った実装をしているので、ParticleSystemのDurarionとPowerを同じ値にしていただければうまい具合に消えると思います。
この辺りはCustomDataモジュールを使えば、もっと良い感じに動かせられると思います。

![削り](https://github.com/NaokiYokota/C93_unity_book_effect_sample/blob/Image/Image/kezuriChange.png "削り")


### 歪みシェーダー - DistortionShader
MaskでUVスクロールをするテクスチャ領域設定しています。
スクロールの向きを上手いぐあいに調整をすれば炎のような揺らめいた表現ができそうです。

![歪み](https://github.com/NaokiYokota/C93_unity_book_effect_sample/blob/Image/Image/distChange.png "歪み")


### 風のエフェクト - Wind
ParticleSystemのTrailを使った風のエフェクトのサンプルになります。
Trailはテクスチャを引き伸ばしている利用をしている関係で、一つのテクスチャだけですと不自然に見えます。

![風](https://github.com/NaokiYokota/C93_unity_book_effect_sample/blob/Image/Image/wind.png "風")
