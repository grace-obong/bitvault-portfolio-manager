;; Title: BitVault Portfolio Manager
;; Summary: 
;;   Decentralized portfolio management protocol for Bitcoin Layer 2 ecosystems
;;
;; Description:
;;   BitVault empowers users to create, manage, and automatically rebalance 
;;   diversified cryptocurrency portfolios on the Stacks blockchain. Built with 
;;   Bitcoin's security principles in mind, this protocol offers institutional-grade 
;;   portfolio management tools including automated rebalancing, multi-asset 
;;   allocation strategies, and comprehensive risk management features. Perfect 
;;   for DeFi enthusiasts seeking sophisticated portfolio optimization while 
;;   maintaining full custody of their assets.
;;
;; Features:
;;   - Multi-asset portfolio creation with up to 10 tokens per portfolio
;;   - Automated rebalancing with customizable triggers
;;   - Percentage-based allocation management
;;   - User-specific portfolio tracking and history
;;   - Protocol fee structure for sustainable development
;;   - Comprehensive error handling and validation

;; ERROR CODES
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-PORTFOLIO (err u101))
(define-constant ERR-INSUFFICIENT-BALANCE (err u102))
(define-constant ERR-INVALID-TOKEN (err u103))
(define-constant ERR-REBALANCE-FAILED (err u104))
(define-constant ERR-PORTFOLIO-EXISTS (err u105))
(define-constant ERR-INVALID-PERCENTAGE (err u106))
(define-constant ERR-MAX-TOKENS-EXCEEDED (err u107))
(define-constant ERR-LENGTH-MISMATCH (err u108))
(define-constant ERR-USER-STORAGE-FAILED (err u109))
(define-constant ERR-INVALID-TOKEN-ID (err u110))

;; DATA VARIABLES
(define-data-var protocol-owner principal tx-sender)
(define-data-var portfolio-counter uint u0)
(define-data-var protocol-fee uint u25) ;; 0.25% represented as basis points

;; CONSTANTS
(define-constant MAX-TOKENS-PER-PORTFOLIO u10)
(define-constant BASIS-POINTS u10000)

;; DATA MAPS
(define-map Portfolios
  uint ;; portfolio-id
  {
    owner: principal,
    created-at: uint,
    last-rebalanced: uint,
    total-value: uint,
    active: bool,
    token-count: uint,
  }
)

(define-map PortfolioAssets
  {
    portfolio-id: uint,
    token-id: uint,
  }
  {
    target-percentage: uint,
    current-amount: uint,
    token-address: principal,
  }
)

(define-map UserPortfolios
  principal
  (list 20 uint)
)

;; READ-ONLY FUNCTIONS

;; Get portfolio information by ID
(define-read-only (get-portfolio (portfolio-id uint))
  (map-get? Portfolios portfolio-id)
)

;; Get specific asset information within a portfolio
(define-read-only (get-portfolio-asset
    (portfolio-id uint)
    (token-id uint)
  )
  (map-get? PortfolioAssets {
    portfolio-id: portfolio-id,
    token-id: token-id,
  })
)

;; Get all portfolios owned by a user
(define-read-only (get-user-portfolios (user principal))
  (default-to (list) (map-get? UserPortfolios user))
)