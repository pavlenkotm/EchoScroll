;; Clarity Smart Contract for Stacks Blockchain
;; A simple counter contract demonstrating Clarity's decidable language features

;; Define data vars
(define-data-var counter uint u0)
(define-data-var contract-owner principal tx-sender)

;; Define constants
(define-constant ERR-NOT-OWNER (err u100))
(define-constant ERR-OVERFLOW (err u101))

;; Read-only functions
(define-read-only (get-counter)
    (ok (var-get counter))
)

(define-read-only (get-owner)
    (ok (var-get contract-owner))
)

;; Public functions
(define-public (increment)
    (let
        (
            (current-value (var-get counter))
        )
        (asserts! (< current-value u4294967295) ERR-OVERFLOW)
        (var-set counter (+ current-value u1))
        (ok (var-get counter))
    )
)

(define-public (decrement)
    (let
        (
            (current-value (var-get counter))
        )
        (asserts! (> current-value u0) (err u102))
        (var-set counter (- current-value u1))
        (ok (var-get counter))
    )
)

(define-public (reset)
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-OWNER)
        (var-set counter u0)
        (ok u0)
    )
)

(define-public (set-counter (new-value uint))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-OWNER)
        (var-set counter new-value)
        (ok new-value)
    )
)

;; Transfer ownership
(define-public (transfer-ownership (new-owner principal))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-OWNER)
        (var-set contract-owner new-owner)
        (ok true)
    )
)

;; Clarity Token Contract
(define-fungible-token clarity-token)

(define-public (mint (amount uint) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-OWNER)
        (ft-mint? clarity-token amount recipient)
    )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) ERR-NOT-OWNER)
        (ft-transfer? clarity-token amount sender recipient)
    )
)

(define-read-only (get-balance (account principal))
    (ok (ft-get-balance clarity-token account))
)

(define-read-only (get-total-supply)
    (ok (ft-get-supply clarity-token))
)
