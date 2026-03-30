# SNet-Claude

[English version](README.md)

[SNet CTFシリーズ](https://github.com/hrmtz/SNet)のAIトレーナー設定リポジトリ。

このリポジトリはプロビジョニング時にサンドボックスVM（cage）内に自動的にcloneされます。暗号化されたシナリオ指示、Claude Codeフック、共通ゲームメカニクスが含まれています。**手動でcloneする必要はありません。**

## 構成

```
SNet-Claude/
├── .claude/              # Claude Code フックと設定
│   ├── hooks/            # ゼロトラスト・ゲームメカニクス
│   └── settings.json     # 権限設定
├── shared/               # 全シナリオ共通のアドオン
│   ├── gis.enc
│   └── njslyr.enc
├── SNet/                 # SNet1 シナリオファイル
│   ├── CLAUDE.md         # トレーナー指示（暗号パズル）
│   ├── claude.md.enc     # 暗号化ゲーム設定
│   ├── install.sh.enc    # 暗号化セットアップスクリプト
│   ├── modes.enc         # 隠しゲームモード
│   └── README.md         # SNet1 シナリオ説明
└── SNet2/                # SNet2 シナリオファイル
    ├── CLAUDE.md         # トレーナー指示（暗号パズル）
    ├── claude.md.enc     # 暗号化ゲーム設定
    ├── install.sh.enc    # 暗号化セットアップスクリプト
    ├── modes2.enc        # 隠しゲームモード
    └── README.md         # SNet2 シナリオ説明
```

## 仕組み

プレイヤーが[SNet](https://github.com/hrmtz/SNet)リポジトリから `vagrant up` を実行すると:

1. cage VMがこのリポジトリを `~/.snet-claude/` にclone
2. シナリオ固有ファイル（CLAUDE.md、暗号化ファイル）がアクティブなシナリオディレクトリにコピーされる
3. Claude Codeフックがゲームエンジンとして機能 — パスフレーズ検出、モード切替、セッション永続化
4. プレイヤーはClaude Codeと対話し、ClaudeがCLAUDE.mdと暗号化された指示に従う

## フック

全フックはゼロトラスト設計 — ファイル名やパスフレーズのハードコードなし。全`.enc`ファイルに対して復号を試行する。

| フック | トリガー | 目的 |
|------|---------|---------|
| `env-check.sh` | 毎プロンプト | 隠しパスフレーズの検出（入力のsha256） |
| `mode-switch.sh` | 毎プロンプト | アドオンモードの有効化（入力をそのままパスフレーズに） |
| `session-init.sh` | セッション開始 | ゲーム状態の復元（compliceモード、アクティブアドオン） |

## 暗号化ファイル

`.enc`ファイルにはゲームシナリオの指示とスクリプトが含まれています。暗号化はネタバレ防止のためであり、悪意のある内容は一切ありません。復号と実行はすべてサンドボックスVM（cage）内で完結し、ホストシステムや外部ネットワークへのアクセスはありません。中身を確認したい場合は、CLAUDE.md内に埋め込まれた鍵を使って自分で復号できます。

## 新シナリオの追加

1. `SNetN/` ディレクトリを作成し、CLAUDE.md、claude.md.enc、install.sh.enc、modes.encを配置
2. 共通アドオンがあれば `shared/` に追加
3. フックは新しい `.enc` ファイルを自動検出 — コード変更は不要

## 関連リポジトリ

- [SNet](https://github.com/hrmtz/SNet) — Vagrantfileとプロビジョニング（ここから始める）
- [SNet2](https://github.com/hrmtz/SNet2) — アーカイブ済み（SNetに統合）

## ライセンス

本プロジェクトは教育目的でのみ提供されます。責任ある使用をお願いします。
