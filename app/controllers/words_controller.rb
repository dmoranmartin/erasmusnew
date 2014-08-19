class WordsController < ApplicationController
	  before_filter :authenticate_user!, except: [:index]
		  add_breadcrumb "home", :root_path
  	def find_words
  		@words= Word.all
		@words_found = @words.where "name LIKE ?", "%#{params[:name]}%"
		unless @words_found.empty? 
		#título parecido al introducido
			render 'find_words'
		else 
		flash[:alert] = 'We could not find it all...?'
		@alphabet = ("a".."z").to_a
			render 'index'
		end	
	end

	def index
		@words = Word.order(name: :asc)
		@words_name = @words.map(&:name)
		gon.words = @words_name
		@words_id = @words.map(&:id)
		gon.words_id= @words_id
		@alphabet = ("a".."z").to_a


		add_breadcrumb "words", words_path
	end

	def new
		@word = Word.new
		 @word.definitions << Definition.new
		 add_breadcrumb "new", new_word_path
	end

	def create
		@word = Word.new entry_params

		if @word.save
			redirect_to action: 'index', controller:'words'
		else
			flash[:alert] = 'Something failed'
			render 'new'
		end
	end

	def show
		@word = Word.find params[:id]
	end

	def edit
		@word = Word.find params[:id]

	end

	def update
		@word = Word.find params[:id]
		if @word.update_attributes entry_params
			redirect_to action: 'index', controller: 'words', id: @word.id
			flash[:notice] = 'Word edited succesfully!'
		else
			flash[:alert] = 'Something failed'
			render 'edit'
		end
	end

	def destroy
		@word = Word.find params[:id]
		@word.destroy
		redirect_to action: 'index', controller: 'words', id: @word.id
	end


	private

	def entry_params
		params.require(:word).permit(:name, :language, definitions_attributes: [:origin, :text, :video, :category, :example])
	end

end
