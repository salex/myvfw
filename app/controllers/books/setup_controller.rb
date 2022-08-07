class Books::SetupController < BooksController
  # before_action :set_book, only: [:show, :new, :update, :destroy]
  before_action :require_book

  def index
    @books = Current.client.books.all
  end

  def preview
    if params[:setup_id] == 'clone'
      @accounts = Books::Setup.clone_book_tree
    else
      file_name = params[:setup_id]+'.csv'
      arr = Books::Setup.parse_csv(file_name)
      @accounts = arr[0]
      # @tree = arr[1]

      @accounts.each do |acct|
        if acct[:account_type] == 'ROOT'
          acct[:code] = acct[:account_type]
        end
        if acct[:level] == 1
          acct[:code] = acct[:account_type]
        end
        if acct[:name].include?('Checking')
          acct[:code] = 'CHECKING'
        end
        if acct[:name].include?('Saving')
          acct[:code] = 'SAVING'
        end
        if acct[:name].include?('Current') && acct[:account_type] == "ASSET"
          acct[:code] = 'CURRENT'
        end
      end
    end
    render 'setup/show'
  end

  def create
    if params[:id] == 'clone'
      @accounts = Books::Setup.clone_book_tree
      # @book = Book.new(root:params[:option])
    else
      file_name = params[:setup_id]+'.csv'
      arr = Books::Setup.parse_csv(file_name)
      @accounts = arr[0]
      # @tree = arr[1]
      @accounts.each do |acct|
        if acct[:account_type] == 'ROOT'
          acct[:code] = acct[:account_type]
        end
        if acct[:level] == 1
          acct[:code] = acct[:account_type]
        end
        if acct[:name].include?('Checking')
          acct[:code] = 'CHECKING'
        end
        if acct[:name].include?('Saving')
          acct[:code] = 'SAVING'
        end
        if acct[:name].include?('Current') && acct[:account_type] == "ASSET"
          acct[:code] = 'CURRENT'
        end
      end

      book = Books::Setup.create_book_tree(@accounts)
      # this is going to call the create action in Book, not setup
      # @book = Book.new(root:params[:option])
    end
    redirect_to books_path, notice:'New Book and Accounts created'

  end

  private
  def set_book
  end
    

end