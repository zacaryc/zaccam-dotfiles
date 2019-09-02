" Vim Syntax file
" Language:     PPSS
" Maintainer:   Zac Campbell
" Filenames:    *.ppss
" Last Change:  20190812

" Quit when a custom syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'markdown'
endif

let s:cpo_save = &cpo
set cpo&vim

syn case match

syn keyword	ppssFunction ACCOUNT_DATE_FIELD ACCOUNT_NUMERIC_FIELD ACCOUNT_TEXT_FIELD ADD_DAYS ADD_MONTHS ADD_TIME AGREEMENT_DATE_FIELD AGREEMENT_NUMERIC_FIELD AGREEMENT_TEXT_FIELD AVERAGE BENCHMARK CAPITAL_CHARGE CEILING CONCATENATE CONSTANT CONSTITUENT_ATTRIBUTE_VALUE CURRDATE CURRTIME CUSTOM_DATE CUSTOM_NUMBER CUSTOM_STRING DATASET_DATE_LOOKUP DATASET_LOOKUP DAYS_DIFF DAYS_OLD DIM_LEVEL DIM_REMOVE DIM_SET_LEVEL DIM_SET_VALUE DIM_VALUE EFFECTIVE_END_DATE EFFECTIVE_START_DATE EFFECTIVE_START_TIME ELEMENT_SCALE_PRICE ERROR EVAL_DATE EXCHANGE_RATE FIRST_DAY_OF_MONTH FLOOR FORECAST_LOOKUP GET_SEGMENT HEADER_DATE_FIELD HEADER_NUMERIC_FIELD HEADER_TEXT_FIELD HISTORICAL_VOLUME IF INDEXVAL IS_VARIANT_PRODUCT ITEM_COUNT_BY_DIM_VALUE ITEM_SUM ITEM_SUM_BY_DIM_VALUE LAST_DAY_OF_MONTH LAST_WKDAY LEADER_PRICE LINEADDED_DATE LINEADDED_TIME LINEITEMPRICE_DATE LINEITEMPRICE_TIME LINEITEMSTART_DATE LINE_ITEM_DATE_OVERRIDE LINE_ITEM_FORMULA_CHANGE_DATE LINE_ITEM_FORMULA_CHANGE_VALUE LINE_ITEM_INTERVAL_VOLUME LINE_ITEM_NEXT_BENCHMARK_DATE LINE_ITEM_NEXT_BENCHMARK_VALUE LINE_ITEM_NEXT_PRICE_DATE LINE_ITEM_NEXT_PRICE_VALUE LINE_ITEM_NUMBER_OVERRIDE LINE_ITEM_OVERRIDDEN LINE_ITEM_STRING_OVERRIDE LINE_ITEM_TOTAL_VOLUME LN LOG LOOKUP LOOKUP_DIM_VALUE MAX MEASURE_LOOKUP MIN MONTHAVG MOVAVG NAMELOOKUP NEW_BENCHMARK NEW_PRICE NEW_TEXT_STRING NEXT_BUSINESS_DAY NEXT_PRICE NEXT_PRICE_DATE NEXT_PRICE_TIME OBJECTIVE OPPORTUNITY_ID ORIGINAL_END_DATE ORIGINAL_START_DATE PLAN_DELAY PLAN_EFFECTIVE_DATE PLAN_LAST_EFFECTIVE_DATE PLAN_MODIFIER PLAN_NEXT_PENDING_DATE POWER PRICE PRICE_CURRENCY PRICE_DATE PRICE_END_DATE PRICE_PER_QUANTITY PRICE_RAW_VALUE PRICE_START_DATE PRICE_START_TIME PRICE_TIME PRICE_UOM PRICING_GUIDANCE PRICING_LEVEL_CODE PRICING_LEVEL_DESC PRICING_METHOD PRICING_REASON PRIOR_INTERVAL_VALUE RANK RANK_DESCENDING REBATE REMOVE_TIME ROUND SAPCONDITION SERVICE_END_DATE SERVICE_START_DATE SET_TIME SQRT SUM TEXT_STRING TO_STRING TRYINORDER VARIANT_ATTRIBUTE_NUMBER VARIANT_ATTRIBUTE_TEXT VARIANT_BASE_PRICE VARIANT_CONTEXT_DATE VARIANT_CONTEXT_NUMBER VARIANT_CONTEXT_STRING VARIANT_TOTAL_OPTIONS VARIANT_TOTAL_PRICE VOLUME WINRATE WINRATE_OPTIMAL WINRATE_STATS


syn region ppssString       start=+"+ skip=+\\\\\|\\"+ end=+"+
syn region ppssParen        start='(' end=')' transparent fold

" Integers
syn match       ppssDecimalInt        "\<-\=\d\+\%([Ee][-+]\=\d\+\)\=\>"
syn match       ppssHexadecimalInt    "\<-\=0[xX]\x\+\>"
syn match       ppssOctalInt          "\<-\=0\o\+\>"
syn match       ppssOctalError        "\<-\=0\o*[89]\d*\>"

" Floating point
syn match       ppssFloat             "\<-\=\d\+\.\d*\%([Ee][-+]\=\d\+\)\=\>"
syn match       ppssFloat             "\<-\=\.\d\+\%([Ee][-+]\=\d\+\)\=\>"

" Operators
syn match ppssOperator /[-+%<>!&|^*=]=\?/


" Due to performance issues loading
syn sync fromstart
syn sync maxlines=250

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_ppss_syn_inits")
  if version < 508
    let did_ppss_syn_inits = 1
    command -nargs=+ HiLink highlight link <args>
  else
    command -nargs=+ HiLink highlight default link <args>
  endif

    HiLink ppssFunction     Statement
    HiLink ppssFloat        Float
    HiLink ppssString       String
    HiLink ppssParen        Keyword

    HiLink     ppssDecimalInt        Integer
    HiLink     ppssHexadecimalInt    Integer
    HiLink     ppssOctalInt          Integer
    HiLink     ppssOctalError        Error
    HiLink     Integer               Number

    HiLink     ppssOperator          Operator

  delcommand HiLink
endif


let b:current_syntax = "ppss"
if main_syntax == 'ppss'
  unlet main_syntax
endif
let &cpo = s:cpo_save
unlet s:cpo_save

