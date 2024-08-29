import SwiftUI

struct CustomAlertView: View {
    var title: String
    var message: String
    var onCancel: () -> Void
    var onConfirm: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 20) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                
                Text(message)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#020C1C"))
            }
            
            HStack(spacing: 12) {
                Button {
                    onConfirm()
                } label: {
                    HStack(alignment: .center) {
                        Text("종료")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#DA072D"))
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(hex: "#FDECEF"))
                    .cornerRadius(22)
                }
                
                Button {
                    onCancel()
                } label: {
                    HStack(alignment: .center) {
                        Text("취소")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color.white)
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(hex: "#1068FD"))
                    .cornerRadius(22)
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .frame(maxWidth: .infinity)
    }
}
