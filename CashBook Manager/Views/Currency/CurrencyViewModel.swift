import Foundation

final class CurrencyViewModel: StoreViewModel {
    let currencies = Currency.all
    var selectedCode: String { store.currencyCode }
    func select(_ currency: Currency) { store.currencyCode = currency.code }
}
