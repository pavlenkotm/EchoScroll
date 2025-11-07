#![cfg_attr(not(feature = "std"), no_std)]

/// Simple Substrate Pallet for token rewards
pub use pallet::*;

#[frame_support::pallet]
pub mod pallet {
    use frame_support::pallet_prelude::*;
    use frame_system::pallet_prelude::*;
    use sp_runtime::traits::Zero;

    #[pallet::pallet]
    pub struct Pallet<T>(_);

    #[pallet::config]
    pub trait Config: frame_system::Config {
        type RuntimeEvent: From<Event<Self>> + IsType<<Self as frame_system::Config>::RuntimeEvent>;

        /// Maximum reward amount
        #[pallet::constant]
        type MaxReward: Get<u32>;
    }

    /// Storage for user reward balances
    #[pallet::storage]
    #[pallet::getter(fn rewards)]
    pub type Rewards<T: Config> = StorageMap<_, Blake2_128Concat, T::AccountId, u32, ValueQuery>;

    /// Total rewards distributed
    #[pallet::storage]
    #[pallet::getter(fn total_rewards)]
    pub type TotalRewards<T: Config> = StorageValue<_, u32, ValueQuery>;

    /// Events
    #[pallet::event]
    #[pallet::generate_deposit(pub(super) fn deposit_event)]
    pub enum Event<T: Config> {
        /// Reward claimed by user
        RewardClaimed { who: T::AccountId, amount: u32 },
        /// Reward granted to user
        RewardGranted { who: T::AccountId, amount: u32 },
    }

    /// Errors
    #[pallet::error]
    pub enum Error<T> {
        /// Reward amount exceeds maximum
        RewardTooLarge,
        /// No rewards available to claim
        NoRewardsAvailable,
        /// Arithmetic overflow
        Overflow,
    }

    #[pallet::call]
    impl<T: Config> Pallet<T> {
        /// Grant rewards to a user
        #[pallet::weight(10_000)]
        #[pallet::call_index(0)]
        pub fn grant_reward(
            origin: OriginFor<T>,
            beneficiary: T::AccountId,
            amount: u32,
        ) -> DispatchResult {
            ensure_root(origin)?;

            ensure!(
                amount <= T::MaxReward::get(),
                Error::<T>::RewardTooLarge
            );

            Rewards::<T>::mutate(&beneficiary, |balance| {
                *balance = balance.saturating_add(amount);
            });

            TotalRewards::<T>::mutate(|total| {
                *total = total.saturating_add(amount);
            });

            Self::deposit_event(Event::RewardGranted {
                who: beneficiary,
                amount,
            });

            Ok(())
        }

        /// Claim available rewards
        #[pallet::weight(10_000)]
        #[pallet::call_index(1)]
        pub fn claim_reward(origin: OriginFor<T>) -> DispatchResult {
            let who = ensure_signed(origin)?;

            let reward = Rewards::<T>::take(&who);
            ensure!(!reward.is_zero(), Error::<T>::NoRewardsAvailable);

            // Here you would transfer actual tokens to the user
            // For this example, we just emit an event
            Self::deposit_event(Event::RewardClaimed {
                who,
                amount: reward,
            });

            Ok(())
        }

        /// Check reward balance
        #[pallet::weight(10_000)]
        #[pallet::call_index(2)]
        pub fn get_reward_balance(
            origin: OriginFor<T>,
            account: T::AccountId,
        ) -> DispatchResult {
            ensure_signed(origin)?;

            let _balance = Rewards::<T>::get(&account);
            // In a real implementation, this would return the value

            Ok(())
        }
    }
}
