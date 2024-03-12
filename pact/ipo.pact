; =================================================================================================================================================================================== ;
;                                                                       Smart Pacts: Digital Initial Public Offering                                                                  ;
;                                                                                  03 of March of 2024                                                                                ;
;                                                                                     smartpacts.io                                                                                   ;
; =================================================================================================================================================================================== ;
;                                                                                                                                                                                     ;
;                                                                                                                                                                                     ;
; Offering Overview Summary                                                                                                                                                           ;
;                                                                                                                                                                                     ;
; This summary highlights selected information contained elsewhere in this offering. This summary does not contain all the information you should consider before investing           ;
; in the securities of Smart Pacts.                                                                                                                                                   ;
; You should read the entire Contract carefully, including the "Digital Shareholder Agreement" and "White Paper" before making an investment decision.                                ;
;                                                                                                                                                                                     ;
; Company Overview:                                                                                                                                                                   ;
; Smart Pacts (The "Company") aims to revolutionize the accessibility and understanding of smart contracts by offering simplified and user-friendly solutions.                        ;
; Our innovative platform empowers users with the tools they need to create, manage, and understand smart contracts without requiring advanced technical knowledge.                   ;
;                                                                                                                                                                                     ;
; Offering:                                                                                                                                                                           ;
; Smart Pacts is offering shares of its common stock at a price of 10 KDA per share.                                                                                                  ;
;                                                                                                                                                                                     ;
; Objective:                                                                                                                                                                          ;
; The primary objectives of this offering are to raise capital for further development of our platform, expand our market reach, and provide liquidity to our employees.              ;
;                                                                                                                                                                                     ;
; Offering Details:                                                                                                                                                                   ;
; - Price Per Share: 10 KDA                                                                                                                                                           ;
; - Total Shares Offered: 250,000 Shares                                                                                                                                              ;
; - Proceeds: 2,500,000 KDA                                                                                                                                                           ;
;                                                                                                                                                                                     ;
; Use of Proceeds:                                                                                                                                                                    ;
; The net proceeds from this offering will be used for the following purposes:                                                                                                        ;
; - Development of new features and technologies for our platform.                                                                                                                    ;
; - Marketing and sales activities to expand our customer base.                                                                                                                       ;
; - General corporate purposes, including working capital and operational expenses.                                                                                                   ;
;                                                                                                                                                                                     ;
; =================================================================================================================================================================================== ;
;                                                                                                                                                                                     ;
; ======= DEPLOYMENT ========================================================== ; Deployment Section.                                                                                 ;
                                                                                                                                                                                      ;
(namespace "smartpacts")                                                        ; A "namespace" is a unique scope named "smartpacts" where the Module will live in.                   ;
                                                                                ;                                                                                                     ;
                                                                                ; To ensure the ownership of the keysets that govern the Module, we                                   ;
(enforce-guard (keyset-ref-guard "smartpacts.shares-admin-keyset"))             ; Enforce the transaction to be signed by "smartpacts.shares-admin-keyset".                           ;
                                                                                ;                                                                                                     ;
; ====== DIGITAL INITIAL PUBLIC OFFERING  ===================================== ; Digital Shareholder Agreement Section.                                                              ;
                                                                                ;                                                                                                     ;
(module shares-ipo GOVERNANCE                                                   ; The Module declared as "shares-ipo" protected by GOVERNANCE capability.                             ;
    @doc "Smart Contract Shares Initial Public Offering."                       ; Public Documentation "Smart Contract Shares Initial Public Offering.".                              ;
                                                                                ;                                                                                                     ;
; ======= MAIN MODULE CAPABILITIES ============================================ ; Main Module Capabilities Section                                                                    ;
                                                                                ;                                                                                                     ;
(defcap GOVERNANCE ()                                                           ; Defines Capability GOVERNANCE that requires no imputs                                               ;
@doc "Give the admin full access to upgrade the module."                        ; Public Documentation "Give the admin full access to upgrade the module.".                           ;
  (enforce-guard (keyset-ref-guard "smartpacts.shares-admin-keyset"))           ; Requires "smartpacts.shares-admin-keyset" owner's signature for GOVERNANCE transactions.            ;
)                                                                               ;                                                                                                     ;
                                                                                ;                                                                                                     ;
(defcap SHARES-MANAGER ()                                                       ; Defines Capability SHARES-MANAGER that requires no imputs                                           ;
@doc "Give the manager access to private functions."                            ; Public Documentation "Give the manager access to private functions.".                               ;
  (enforce-guard (keyset-ref-guard "smartpacts.shares-manager-keyset"))         ; Requires "smartpacts.shares-manager-keyset" owner's signature for SHARES-MANAGER transactions.      ;
)                                                                               ; SHARES-MANAGER is required in all private functions.                                                ;
                                                                                ;                                                                                                     ;
; ======= IMPORTS ============================================================= ;                                                                                                     ;
                                                                                ; The "use" statement allows a Smart Contract to access functions,                                    ;
(use coin)                                                                      ; variables, or data defined in another Module or Namespace.                                          ;
(use smartpacts.shares)                                                         ; Imports all functions, variables and available data defined within the native Coin Smart Contract   ;
                                                                                ; and the Smart Pacts Digital Shareholder Agreement.                                                  ;
; ======= INITIAL PUBLIC OFFER CONSTANTS ====================================== ;                                                                                                     ;
                                                                                ;                                                                                                     ;
(defconst IPO_ACCOUNT:string (create-principal                                  ; Creates Shares Principal Account based on                                                           ;
    (create-capability-guard (IPO-OWNERSHIP)))                                  ; IPO-OWNERSHIP Capability as IPO_ACCOUNT                                                             ;
  "Self-managed Principal IPO Account.")                                        ; Public Documentation "Self-managed Principal IPO Account."                                          ;
                                                                                ;                                                                                                     ;
(defconst IPO_SHARES_PRICE_KDA:decimal 10.0                                     ; Defines constant for IPO Shares price at ten (10.0) KDA per Share as "IPO_SHARES_PRICE_KDA"         ;
  "Initial Public Offering Price: 10 KDA per Share.")                           ; Public Documentation "Initial Public Offering Price: 10 KDA per Share.".                            ;
                                                                                ;                                                                                                     ;
; ======= INITIAL PUBLIC OFFER CAPACITIES ===================================== ;                                                                                                     ;
                                                                                ;                                                                                                     ;
(defcap IPO-OWNERSHIP:bool ()                                                   ; Defines SHARES-OWNERSHIP Capability and requires no imputs.                                         ;
@doc "Initial Public Offering ownership managed capability."                    ; Public Documentation "Initial Public Offering ownership managed capability.".                       ;
  true                                                                          ; Where the Module is always entitle to this Capability.                                              ;
)                                                                               ;                                                                                                     ;
                                                                                ;                                                                                                     ;
(defcap BUY-IPO:bool (receiver:string amount:decimal)                           ; BUY-IPO Capability requires a Shares receiver Account and a Shares Amount to receive.               ;                                                                         ;
  (enforce (!= receiver "") "valid receiver")                                   ; Enforces that Shares receiver Account is not empy ("") and                                          ;
  (enforce (> amount 0.0) "Positive amount")                                    ; enforces that Shares Amount to receive is not zero (0.0).                                           ;
)                                                                               ;                                                                                                     ;
                                                                                ;                                                                                                     ;                                                                           ;                                                                                                     ;
; ======= INITIAL PUBLIC OFFER FUNCTIONS ====================================== ;                                                                                                     ;
                                                                                ;                                                                                                     ;
(defun buy-ipo:string (receiver:string amount:decimal)                          ; "buy-ipo" requires the Shares Account to buy Shares and the amount of shares to buy                 ;
@doc "Buy Smart Pact Public Initial Offering Shares for 10 KDA each."           ; Public Documentation "Buy Smart Pact Public Initial Offering Shares for 10 KDA each.".              ;
  (smartpacts.shares.validate-account receiver)                                 ; Validate with Shares' Contract function that the Shares receiver Account is in complience.          ;
  (smartpacts.shares.enforce-unit amount)                                       ; Validate with Shares' Contract function that the Shares Account to buy is in complience.            ;
  (enforce (> amount 0.0) "transfer amount must be positive")                   ; Enfonces that the Shares amount is greater than zero (0.0).                                         ;
  (with-capability (BUY-IPO receiver amount)                                    ; With Capability BUY-IPO for Shares revicer and amount granted,                                      ;
    (let (                                                                      ; let the following be                                                                                ;
        (kda-amount (floor (* amount IPO_SHARES_PRICE_KDA)                      ; "kda-amount" as Shares Amount to buy times the IPO Shares Price                                     ;
          coin.MINIMUM_PRECISION))                                              ; round to the coin's contract minimum precision.                                                     ;
        (kda-account                                                            ; "receiver-kda-accoint" as                                                                           ;
          (smartpacts.shares.get-kda-account receiver)))                        ; the KDA Address associated to the Shares Revicer's Account                                          ;
      (coin.enforce-unit kda-amount)                                            ; Enforce the total KDA amount to send is in compliance with the Coin Contract                        ;
      (coin.validate-account kda-account)                                       ; Validate with Coin's' Contract function that the KDA receiver Account is in complience.             ;
      (install-capability                                                       ; Instal Capability TRANSFER from Shares Module                                                       ;
        (smartpacts.shares.TRANSFER IPO_ACCOUNT receiver amount))               ; From IPO Account to Shares receiver's Account with Shares Amount to buy.                            ;
      (install-capability                                                       ; Instal Capability TRANSFER from Coin Module                                                         ;
        (coin.TRANSFER kda-account IPO_ACCOUNT kda-amount))                     ; From Shares receiver KDA account to IPO Account with KDA Amount to pay.                             ;
      (coin.transfer kda-account IPO_ACCOUNT kda-amount)                        ; Uses the transfer function from the Coin's Contract to transfer the KDA.                            ;
      (with-capability (IPO-OWNERSHIP)                                          ; With Capability IPO-OWNERSHIP granted,                                                              ;
        (smartpacts.shares.transfer IPO_ACCOUNT receiver amount))               ; Uses the transfer function from the Shares' Contract to transer the Shares.                         ;                                                                                                    ;
      (format "{} shares transfered to {} for {} KDA"                           ; Returns transaction message.                                                                        ;
        [amount receiver kda-amount])))                                         ;                                                                                                     ;
)                                                                               ;                                                                                                     ;
                                                                                ;                                                                                                     ;
(defun get-balance ()                                                           ; "get-balance" requires no imputs                                                                    ;
@doc "Returns Smart Pacts' Initial Public Offering current balance."            ; Public Documentation "Returns Smart Pacts' Initial Public Offering current balance.".               ;
  (smartpacts.shares.get-balance IPO_ACCOUNT)                                   ; Returns balance of Initial Public Offering Shares Account.                                          ;
)                                                                               ;                                                                                                     ;
; ======= GENESIS INITIAL PUBLIC OFFER FUNCTIONS ============================== ;                                                                                                     ;
                                                                                ;                                                                                                     ;
(defun initialize:string ()                                                     ; "initialize" requires no imputs                                                                     ;
@doc "Initialize Smart Pacts Initial Public Offering."                          ; Public Documentation "Initialize Smart Pacts Initial Public Offering.".                             ;
  (with-capability (GOVERNANCE)                                                 ; With Capability GOVERNANCE granted                                                                  ;
    (coin.create-account IPO_ACCOUNT (create-capability-guard (IPO-OWNERSHIP))) ; Create IPO KDA Account using Coin Module                                                            ;
    (smartpacts.shares.create-allocation IPO_ACCOUNT (smartpacts.shares.now)    ; Create a Shares allocation for IPO Shares Account with a time release of now                        ;
      (create-capability-guard (IPO-OWNERSHIP))                                 ; with a Capability Guard                                                                             ;
        smartpacts.shares.SHARES_IPO_GENESIS_SUPPLY)                            ; for the Shares IPO Genesis Supply and                                                               ;
    (smartpacts.shares.release-allocation IPO_ACCOUNT))                         ; Release the Acollation to the IPO Shares Account.                                                   ;
)                                                                               ;                                                                                                     ;
                                                                                ;                                                                                                     ;
(defun get-funds (kda-account:string)                                           ; "get-funds" require a Share account                                                                 ;
@doc "Transfers funds from IPO account to input account."                       ; Public Documentation "Transfers funds from IPO account to input account."                           ;
(coin.validate-account kda-account)                                             ; Validate with Coin's' Contract function that the KDA receiver Account is in complience.             ;
  (with-capability (SHARES-MANAGER)                                             ; With Capability SHARES-MANAGER and                                                                  ;
    (with-capability (IPO-OWNERSHIP)                                            ; With Capability IPO-OWNERSHIP granted                                                               ;
      (install-capability                                                       ; install Capability TRANSFER                                                                         ;
        (coin.TRANSFER IPO_ACCOUNT kda-account (coin.get-balance IPO_ACCOUNT))) ; from IPO Account to provided account with the total IPO balance and                                 ;
      (coin.transfer IPO_ACCOUNT kda-account (coin.get-balance IPO_ACCOUNT))))  ; execute transfer.                                                                                   ;
)                                                                               ;                                                                                                     ;
                                                                                ;                                                                                                     ;
)                                                                               ;                                                                                                     ;
; =================================================================================================================================================================================== ;