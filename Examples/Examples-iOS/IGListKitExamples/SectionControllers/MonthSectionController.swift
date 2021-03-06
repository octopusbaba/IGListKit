/**
 Copyright (c) 2016-present, Facebook, Inc. All rights reserved.
 
 The examples provided by Facebook are for non-commercial testing and evaluation
 purposes only. Facebook reserves all rights not expressly granted.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit
import IGListKit

final class MonthSectionController: IGListBindingSectionController, IGListBindingSectionControllerDataSource, IGListBindingSectionControllerSelectionDelegate {
    
    var selectedDay: Int = -1
    
    override init() {
        super.init()
        dataSource = self
        selectionDelegate = self
    }
    
    // MARK: IGListBindingSectionControllerDataSource
    
    func sectionController(_ sectionController: IGListBindingSectionController, viewModelsFor object: Any) -> [IGListDiffable] {
        guard let month = object as? Month else { return [] }
        
        let date = Date()
        let today = Calendar.current.component(.day, from: date)
        
        var viewModels = [IGListDiffable]()
        
        viewModels.append(MonthTitleViewModel(name: month.name))
        
        for day in 1..<(month.days + 1) {
            let viewModel = DayViewModel(
                day: day,
                today: day == today,
                selected: day == selectedDay,
                appointments: month.appointments[day]?.count ?? 0
            )
            viewModels.append(viewModel)
        }
        
        for appointment in month.appointments[selectedDay] ?? [] {
            viewModels.append(appointment)
        }
        
        return viewModels
    }
    
    func sectionController(_ sectionController: IGListBindingSectionController, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell {
        let cellClass: AnyClass
        if viewModel is DayViewModel {
            cellClass = CalendarDayCell.self
        } else if viewModel is MonthTitleViewModel {
            cellClass = MonthTitleCell.self
        } else {
            cellClass = LabelCell.self
        }
        return collectionContext?.dequeueReusableCell(of: cellClass, for: self, at: index) ?? UICollectionViewCell()
    }
    
    func sectionController(_ sectionController: IGListBindingSectionController, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { return .zero }
        if viewModel is DayViewModel {
            let square = width / 7.0
            return CGSize(width: square, height: square)
        } else if viewModel is MonthTitleViewModel {
            return CGSize(width: width, height: 30.0)
        } else {
            return CGSize(width: width, height: 55.0)
        }
    }
    
    // MARK: IGListBindingSectionControllerSelectionDelegate
    
    func sectionController(_ sectionController: IGListBindingSectionController, didSelectItemAt index: Int, viewModel: Any) {
        guard let dayViewModel = viewModel as? DayViewModel else { return }
        if dayViewModel.day == selectedDay {
            selectedDay = -1
        } else {
            selectedDay = dayViewModel.day
        }
        update(animated: true)
    }

}
