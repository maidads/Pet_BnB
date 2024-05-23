//
//  ChatsListView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-23.
//

import SwiftUI


struct ChatsListView: View {
    @StateObject var vm: ChatsListViewModel = ChatsListViewModel()
    
    
    var body: some View {
        List{
            ForEach(vm.chats){ chat in
                NavigationLink(destination: ChatView(vm: ChatViewModel(toUserID: String, chat: <#T##Chat?#>))){
                    ChatListRow(chat: chat, user: vm.getUserFromID(chat: chat))
                }
             
            }
            
        }
    }
}

struct ChatListRow: View{
    var chat: Chat
    var user: User?
    var body: some View{
        VStack(alignment: .leading){
            if let name = user?.firstName{
                Text(name)
                    .bold()
            } else {
                Text("No name")
                    .bold()
            }
            Text(chat.lastMessage)
        }
    }
}

#Preview {
    ChatsListView()
}
