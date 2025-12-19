//
//  AllWorkoutsView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct AllWorkoutsView: View {
    @Environment(NavigationCoordinator.self) private var navigation
    @Environment(\.dismiss) private var dismiss
    @Environment(AllWorkoutsViewModel.self) private var viewModel

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                header
                searchBar
                filterTabs
                workoutsList
            }
            .padding(.horizontal, 16)
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CustomColor.primary)
            }

            Spacer()
        }
        .padding(.top, 10)

        VStack(alignment: .leading, spacing: 8) {
            Text("All Workouts")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)
        }
        .padding(.top, 10)
    }

    @ViewBuilder
    private var searchBar: some View {
        @Bindable var viewModel = viewModel
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))

                TextField("Search workouts...", text: $viewModel.searchText)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .autocorrectionDisabled()

                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.clearSearch()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
            )
        }
    }

    @ViewBuilder
    private var filterTabs: some View {
        HStack(spacing: 12) {
            ForEach(WorkoutFilter.allCases, id: \.self) { filter in
                FilterTab(
                    title: filter.rawValue,
                    isSelected: viewModel.selectedFilter == filter
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.changeFilter(to: filter)
                    }
                }
            }

            Spacer()
        }
    }

    @ViewBuilder
    private var workoutsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if viewModel.filteredWorkouts.isEmpty {
                    emptyState
                } else {
                    ForEach(viewModel.filteredWorkouts) { workout in
                        WorkoutCard(
                            title: workout.title,
                            exercises: workout.exercises,
                            time: workout.time,
                            isCompleted: workout.isCompleted,
                            date: workout.date
                        ) {
                            navigation.push(HomeScreen.workoutDetail(workout))
                        }
                    }
                }
            }
            .padding(.bottom, 100)
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 60, weight: .semibold))
                .foregroundColor(.white.opacity(0.3))

            Text("No workouts found")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            Text("Try adjusting your filters or search")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.top, 60)
    }
}

#Preview {
    NavigationStack {
        AllWorkoutsView()
    }
    .environment(NavigationCoordinator())
    .environment(AllWorkoutsViewModel())
}
