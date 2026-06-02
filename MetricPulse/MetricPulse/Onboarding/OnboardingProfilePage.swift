import SwiftUI

struct OnboardingProfilePage: View {
    @Binding var name: String
    @Binding var market: String

    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            VStack(spacing: 6) {
                Text("Your Profile").font(.title2.bold())
                Text("Optional — used to personalize your dashboard.")
                    .font(.subheadline).foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 12) {
                TextField("Your name (e.g. David)", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.givenName)

                TextField("Your market (e.g. San Diego)", text: $market)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.addressCity)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
    }
}
