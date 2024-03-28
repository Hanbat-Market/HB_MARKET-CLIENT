//
//  TradeView.swift
//  hanbat-market
//
//  Created by dongs on 3/28/24.
//

import SwiftUI

struct TradeView: View {
    
    var nickname: String = ""
    var articleId: Int = 0
    
    @StateObject var tradeVM = TradeVM()
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate = Date()
    @State private var isDatePickerPresented = false
    
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @State private var isTimePickerPresented = false
    
    @State private var reservationPlace: String = ""
    
    var body: some View {
        VStack() {
            BackNavigationBar(navTitle: "\(String(describing: nickname))님과 거래 예약")
            
            ScrollView {
                
                VStack(spacing: 0){
                    HStack {
                        Text("날짜")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            isDatePickerPresented.toggle()
                        }, label: {
                            Text(DateUtils.formatDate(selectedDate))
                            Image(systemName: "chevron.down")
                        })
                        .foregroundStyle(CommonStyle.BLACK_COLOR)
                        .padding()
                        .sheet(isPresented: $isDatePickerPresented, content: {
                            Spacer().frame(height: 30)
                            DatePicker(selection: $selectedDate, in: Date()..., displayedComponents: .date) {
                                Text("날짜를 선택해주세요.")
                            }
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                            .presentationDetents([
                                .fraction(0.6),
                                .medium,
                            ])
                        })
                    }
                    
                    Divider()
                        .background(CommonStyle.MAIN_COLOR)
                }
                
                VStack(spacing: 0){
                    HStack {
                        Text("시간")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            isTimePickerPresented.toggle()
                        }, label: {
                            Text("\(selectedHour)시 \(selectedMinute)분")
                            Image(systemName: "chevron.down")
                        })
                        .foregroundStyle(CommonStyle.BLACK_COLOR)
                        .padding()
                        .sheet(isPresented: $isTimePickerPresented, content: {
                            GeometryReader { geometry in
                                VStack(alignment: .center) {
                                    HStack(spacing: 0) {
                                        Picker("시 선택", selection: $selectedHour) {
                                            ForEach(0..<24, id: \.self) { hour in
                                                Text("\(hour)")
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                        .frame(width: geometry.size.width/5, height: 250)
                                        .clipped()
                                        Text("시")
                                        Spacer().frame(width: 50)
                                        
                                        Picker("분 선택", selection: $selectedMinute) {
                                            ForEach(0..<60, id: \.self) { minute in
                                                Text("\(minute)")
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                        .frame(width: geometry.size.width/5, height: 250)
                                        .clipped()
                                        Text("분")
                                    }
                                    
                                }
                                .frame(width: UIScreen.main.bounds.width)
                            }.presentationDetents([
                                .fraction(0.35),
                                .medium,
                            ])
                        })
                        
                    }
                    
                    Divider()
                        .background(CommonStyle.MAIN_COLOR)
                }
                
                VStack(spacing: 0){
                    HStack(alignment:.center) {
                        Text("거래 장소")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        TextField("자세한 거래 장소를 입력해주세요.", text: $reservationPlace)
                            .multilineTextAlignment(.trailing)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                    }
                    
                    Divider()
                        .background(CommonStyle.MAIN_COLOR)
                }
                
            }
            .padding(.horizontal, 16)
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
            
            Spacer()
            
            if tradeVM.isLoadingtradeReservation {
                VStack{
                    Spacer().frame(height: 50)
                    ProgressView()
                        .controlSize(.large)
                        .progressViewStyle(CircularProgressViewStyle(tint: CommonStyle.MAIN_COLOR))
                    Spacer().frame(height: 30)
                    Text("거래를 확정하는 중이에요!")
                }.fontWeight(.medium)
                
                Spacer()
            }
            
            AuthButton(buttonAction: {
                let dateTime = DateUtils.formatDateTime(date: selectedDate, hour: selectedHour, minute: selectedMinute)
                
                tradeVM.postTradeReservation(purchaserNickname: nickname, articleId: articleId, transactionAppointmentDateTime: dateTime, reservationPlace: reservationPlace)
                
            }, buttonText: "확정하기")
            .padding(.horizontal, 20)
        }
        .alert(isPresented: $tradeVM.tradeReservationFailed, content: {
            Alert(title: Text("예약 실패"), message: Text("예약 내용을 다시 확인해주세요."), dismissButton: .default(Text("확인")))
        })
        .onReceive(tradeVM.tradeReservationSuccess, perform: {_ in 
            self.dismiss()
        })
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    TradeView(nickname: "고릴라", articleId: 0)
}
