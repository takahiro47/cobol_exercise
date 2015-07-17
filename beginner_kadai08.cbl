*> ------------------------------------------------------- <*
*> Run as:
*> $ cobc -x -free -g -debug -Wall beginner_kadai08.cbl; ./beginner_kadai08
*> ------------------------------------------------------- <*

*> ***************************************************************************
*> * 見出し部
*> ***************************************************************************
IDENTIFICATION DIVISION.
  PROGRAM-ID. REIDAI08.


*> ***************************************************************************
*> * 環境部
*> ***************************************************************************
ENVIRONMENT DIVISION.

  INPUT-OUTPUT SECTION.
  FILE-CONTROL.
    SELECT TOUR-MASTER-FILE     ASSIGN TO 'TOUR-MASTER.DAT'   *> INFILE   / ツアーマスタファイル
      ORGANIZATION IS LINE SEQUENTIAL.
    SELECT TOUR-CONTRACT-LIST   ASSIGN TO 'SYSPRINT.DAT'      *> SYSPRINT / ツアー契約リスト
      ORGANIZATION IS LINE SEQUENTIAL.


*> ***************************************************************************
*> * データ部
*> ***************************************************************************
DATA DIVISION.

  *> ファイルの定義
  FILE SECTION.

    *> ツアーマスタファイル
    FD TOUR-MASTER-FILE
      LABEL RECORD IS STANDARD
      BLOCK CONTAINS 0 RECORDS.

    01 TOUR-MASTER-RECORDS      PIC X(50).

    *> ツアー契約リスト
    FD TOUR-CONTRACT-LIST
      LABEL RECORD IS OMITTED.

    01 TOUR-CONTRACT-RECORDS    PIC X(132).

  *> 変数の定義
  WORKING-STORAGE SECTION.

    *> 一時利用
    01 FLAG-FILE-END            PIC 9(01) VALUE ZERO.     *> EODフラグ
    01 FLAG-ON                  PIC 9(01) VALUE 1.        *> 定数 ON
    01 FLAG-OFF                 PIC 9(01) VALUE 0.        *> 定数 OFF
    01 COUNTER                  PIC 9(03) VALUE ZERO.     *> カウンタ

    01 TEMP-EXPENSES-TOTAL      PIC 9(12) VALUE ZERO.     *> 合計

    *> 入力域
    01 INPUT-FORMAT.
      03 IN-TOUR-CODE           PIC X(05).                *> ツアーID
      03 IN-TOUR-NAME           PIC X(10).                *> ツアー名
      03 IN-TOUR-EXPENSES       PIC 9(07).                *> ツアー旅費
      03 IN-TOUR-MEMBERS        PIC 9(04).                *> ツアー参加人数
      03 IN-TOTAL-EXPENSES      PIC 9(11).                *> ツアー金額

    *> 出力ヘッダ(見出し行)
    *> ﾂｱｰﾒｲ___________ﾘｮﾋ**ﾆﾝｽﾞｳ______________ｷﾝｶﾞｸ
    01 PRINT-HEADER.
      03 FILLER                 PIC X(05) VALUE 'ﾂｱｰﾒｲ'.
      03 FILLER                 PIC X(13) VALUE SPACE.
      03 FILLER                 PIC X(05) VALUE 'ﾘｮﾋ  '.
      03 FILLER                 PIC X(05) VALUE 'ﾆﾝｽﾞｳ'.
      03 FILLER                 PIC X(14) VALUE SPACE.
      03 FILLER                 PIC X(05) VALUE 'ｷﾝｶﾞｸ'.

    *> 出力本文(明細行)
    *> (ﾂｱｰﾒｲ )__Z,ZZZ,ZZ9__Z,ZZ9__Z,ZZZ,ZZZ,ZZZ,ZZ9
    01 PRINT-ARTICLE.
      03 PRINT-TOUR-NAME        PIC X(10).
      03 FILLER                 PIC X(02) VALUE SPACE.
      03 PRINT-TOUR-EXPENSES    PIC Z,ZZZ,ZZ9.
      03 FILLER                 PIC X(02) VALUE SPACE.
      03 PRINT-TOUR-MEMBERS     PIC Z,ZZ9.
      03 FILLER                 PIC X(02) VALUE SPACE.
      03 PRINT-TOTAL-EXPENSES   PIC $,$$$,$$$,$$9. *> \,\\\,\\\,\\\,\\9.


*> ***************************************************************************
*> * 手続き部
*> ***************************************************************************
PROCEDURE DIVISION.

*> 基本処理
BASE.
  DISPLAY ''.
  DISPLAY '-- PROGRAM START --'.

  *> 初期化処理
  PERFORM                     INIT.

  *> メイン繰り返し処理
  PERFORM                     MAIN-LOOP
                              UNTIL FLAG-FILE-END = FLAG-ON.

  *> 終了処理
  PERFORM                     FINALIZE.

  *> 終了(最後に止める)
  DISPLAY '-- PROGRAM EXIT   --'.
  STOP RUN.


*> ***************************************************************************
*> * 初期化処理
*> * = ファイルのオープンと読み込み
*> ***************************************************************************
INIT.
  *> ## 初期化処理 ##

  *> ファイルのオープン
  OPEN    INPUT                 TOUR-MASTER-FILE
          OUTPUT                TOUR-CONTRACT-LIST.

  *>## 1ページ目の処理 ##

  *> 見出し行の印刷 + 改ページ
  WRITE   TOUR-CONTRACT-RECORDS FROM PRINT-HEADER AFTER PAGE.

  *> 1行目データの読み込み
  READ    TOUR-MASTER-FILE INTO INPUT-FORMAT
          AT END MOVE FLAG-ON TO FLAG-FILE-END.


*> ***************************************************************************
*> * メイン繰り返し処理
*> * = 合計の計算と明細表の印刷
*> ***************************************************************************
MAIN-LOOP.
  *> デバッグ
  DISPLAY ' IN  : ' INPUT-FORMAT.

  *> *> 合計金額のカウント
  *> COMPUTE TEMP-EXPENSES-TOTAL = TEMP-EXPENSES-TOTAL + IN-TOUR-EXPENSES.
  *> *> 処理件数のカウント
  *> COMPUTE COUNTER = COUNTER + 1.

  *> 明細のフォーマット
  MOVE    IN-TOUR-NAME TO PRINT-TOUR-NAME.
  MOVE    IN-TOUR-EXPENSES TO PRINT-TOUR-EXPENSES.
  MOVE    IN-TOUR-MEMBERS TO PRINT-TOUR-MEMBERS.
  MOVE    IN-TOTAL-EXPENSES TO PRINT-TOTAL-EXPENSES.

  *> 明細の書き込み
  DISPLAY ' OUT :' PRINT-ARTICLE.
  DISPLAY ''
  WRITE   TOUR-CONTRACT-RECORDS FROM PRINT-ARTICLE AFTER 1.

  *> 次のデータの読み込み
  READ    TOUR-MASTER-FILE INTO INPUT-FORMAT
          AT END MOVE FLAG-FILE-END TO FLAG-ON.


*> ***************************************************************************
*> * 終了処理
*> ***************************************************************************
FINALIZE.
  *> 集計のフォーマット
  MOVE    SPACE TO PRINT-ARTICLE.
  MOVE    'ｺﾞｳｹｲ' TO PRINT-TOUR-NAME.
  MOVE    COUNTER TO PRINT-TOUR-MEMBERS.
  MOVE    TEMP-EXPENSES-TOTAL TO PRINT-TOTAL-EXPENSES.

  *> 集計の書き込み
  DISPLAY PRINT-ARTICLE.
  WRITE   TOUR-CONTRACT-RECORDS FROM PRINT-ARTICLE AFTER 2. *> 2行改行

  *> ファイルのクローズ
  CLOSE   TOUR-MASTER-FILE TOUR-CONTRACT-LIST.
