//
//  ContentView.swift
//  Pinch
//
//  Created by Manuel Martinez on 01/07/22.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var currentImageOffset: CGSize = .zero
    @State private var currentImageScale: CGFloat = 1
    @State private var isDrawerOpen: Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 0
    
    // MARK: - FUNCTIONS
    func resetImageState() {
        return withAnimation(.spring()){
            imageScale = 1
            currentImageScale = 1
            imageOffset = .zero
            currentImageOffset = .zero
        }
    }
    
    func changeScale(value: CGFloat) {
        imageScale = value
        currentImageScale = value
    }
    
    
    var body: some View {
        NavigationView{
            
            ZStack{
                Color.clear
                // MARK: - PAGE IMAGE
                Image(pages[pageIndex].imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .scaleEffect(imageScale)
                // MARK: - 1. DOUBLE TAP GESTURE
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                changeScale(value: 5)
                            }
                        } else {
                            resetImageState()
                        }
                    }
                // MARK: - 2. DRAG GESTURE
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                withAnimation(.linear(duration: 1)){
                                    //imageOffset = value.translation
                                    imageOffset.height = value.translation.height + currentImageOffset.height
                                    imageOffset.width = value.translation.width + currentImageOffset.width
                                }
                            }
                            .onEnded{ _ in
                                currentImageOffset.height = imageOffset.height
                                currentImageOffset.width = imageOffset.width
                                print(currentImageOffset)
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                    )
                // MARK: - 3. PINCH GESTURE
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)){
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value + currentImageScale - 1
                                    }
                                }
                            }
                            .onEnded { _ in
                                currentImageScale = imageScale
                                if imageScale <= 1 {
                                    resetImageState()
                                } else if imageScale > 5 {
                                    changeScale(value: 5)
                                }
                            }
                    )
                
            }//: ZStack
            .navigationTitle("Pinch and Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isAnimating = true
            }
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
            // MARK: - CONTROLS
            .overlay(
                Group {
                    HStack {
                        //Scale Down
                        Button {
                            withAnimation(.spring()){
                                
                                if imageScale > 1 {
                                    imageScale -= 1
                                } else if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        //Reset
                        Button {
                            resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        //Scale Up
                        Button {
                            withAnimation(.spring()){
                                if imageScale < 5 {
                                    imageScale += 1
                                } else {
                                    imageScale = 5
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    } // Controls
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
            // MARK: - DRAWER
            .overlay(
                HStack(spacing: 12){
                    // MARK: - DRAWER HANDLE
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                 isDrawerOpen.toggle()
                            }
                        }
                    // MARK: - THUMBNAILS
                    ForEach(pages) { item in
                        Image(item.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = item.id
                            }
                    }
                    
                    Spacer()
                }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                ,alignment: .topTrailing
            )
            
        }//:Navigation
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
