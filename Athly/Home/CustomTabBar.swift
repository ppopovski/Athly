//
//  CustomTabBar.swift
//  Athly
//
//  Created by Petar Popovski on 5.12.25.
//

import SwiftUI
import Foundation

struct TabBarItem: Identifiable {
    let id: Int
    let icon: String
    let title: String
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [TabBarItem]

    @Namespace private var animation

    private let tabBarHeight: CGFloat = 70
    private let indicatorSize: CGFloat = 56

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                tabButton(for: tab)
            }
        }
        .frame(height: tabBarHeight)
        .background(
            RoundedRectangle(cornerRadius: 35)
                .fill(Color.black.opacity(0.9))
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 5)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 10)
    }

    @ViewBuilder
    private func tabButton(for tab: TabBarItem) -> some View {
        let isSelected = selectedTab == tab.id

        Button {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                selectedTab = tab.id
            }
        } label: {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(CustomColor.primary)
                        .frame(width: indicatorSize, height: indicatorSize)
                        .shadow(color: CustomColor.primary.opacity(0.4), radius: 10, x: 0, y: 5)
                        .offset(y: -8)
                        .matchedGeometryEffect(id: "TAB_INDICATOR", in: animation)
                }
                
                Image(systemName: tab.icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .black : .white.opacity(0.6))
                    .offset(y: isSelected ? -8 : 0)
            }
            .frame(maxWidth: .infinity)
            .frame(height: tabBarHeight)
            .contentShape(Rectangle())
        }
    }
}

struct CustomTabBarContainer<Content: View>: View {
    @Binding var selectedTab: Int
    let tabs: [TabBarItem]
    @ViewBuilder let content: (Int) -> Content

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            content(selectedTab)

            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab, tabs: tabs)
        }
    }
}

#Preview {
    @Previewable @State var selectedTab = 0

    let tabs = [
        TabBarItem(id: 0, icon: "house.fill", title: "Home"),
        TabBarItem(id: 1, icon: "calendar", title: "Calendar"),
        TabBarItem(id: 2, icon: "gearshape.fill", title: "Settings")
    ]

    CustomTabBarContainer(selectedTab: $selectedTab, tabs: tabs) { tab in
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            Text("Tab \(tab)")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}
