import RxCocoa
import RxSwift

struct CommentEntity {
    
}

protocol CommentCellViewModelInterface {
    var entity: CommentEntity { get }
}

final class CommentCellViewModel: CommentCellViewModelInterface {
    let entity: CommentEntity

    init(entity: CommentEntity) {
        self.entity = entity
    }
}
