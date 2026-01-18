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

            VStack(alignment: .leading, spacing: 28) {
                header
                searchBar
                filterTabs
                workoutsList
            }
            .padding(.horizontal, 16)
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadWorkouts()
        }
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

            Button {
                withAnimation(.snappy) {
                    navigation.push(HomeScreen.addWorkout)
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CustomColor.primary)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.05))
                    )
                    .overlay(
                        Circle()
                            .stroke(CustomColor.primary.opacity(0.5), lineWidth: 1)
                    )
            }
            .buttonStyle(ScaleButtonStyle())
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
                    .foregroundColor(CustomColor.primary)

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
                            .foregroundColor(CustomColor.primary.opacity(0.7))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(CustomColor.primary.opacity(0.4), lineWidth: 1)
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
                    withAnimation(.snappy) {
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
                            withAnimation(.snappy) {
                                navigation.push(HomeScreen.workoutDetail(workout))
                            }
                        }
                        .transition(AnyTransition.asymmetric(
                            insertion: AnyTransition.move(edge: .bottom).combined(with: .opacity),
                            removal: .opacity
                        ))
                    }
                }
            }
            .padding(.bottom, 100)
            .animation(.snappy, value: viewModel.filteredWorkouts)
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

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        AllWorkoutsView()
    }
    .environment(NavigationCoordinator())
    .environment(AllWorkoutsViewModel())
}
