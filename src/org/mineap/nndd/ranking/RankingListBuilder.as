package org.mineap.nndd.ranking
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	
	import mx.collections.ArrayCollection;
	
	import org.mineap.nicovideo4as.ThumbInfoLoader;
	import org.mineap.nicovideo4as.analyzer.ThumbInfoAnalyzer;
	import org.mineap.nicovideo4as.util.HtmlUtil;
	import org.mineap.nndd.FileIO;
	import org.mineap.nndd.Message;
	import org.mineap.nndd.library.ILibraryManager;
	import org.mineap.nndd.library.LibraryManagerBuilder;
	import org.mineap.nndd.model.NNDDVideo;
	import org.mineap.nndd.util.NicoPattern;
	import org.mineap.nndd.util.NumberUtil;
	import org.mineap.nndd.util.PathMaker;
	
	/**
	 * 
	 * RankingListの
	 * 
	 * @author shiraminekeisuke
	 * 
	 */
	public class RankingListBuilder extends EventDispatcher
	{
		
		private static const CATEGORY_LIST_FILE_NAME:String = "CategoryList.xml";
		
		private static const CATEGORY_VERSION:String = "20120216";
		
		/**
		 * 
		 * 
		 */
		public function RankingListBuilder()
		{
		}
		
		/**
		 * 渡されたランキングのRSS(XML)から、表示用のArrayCollectionを生成します。
		 * 
		 * @param xml
		 * @return 
		 * 
		 */
		public function getRankingArrayCollection(xml:XML, pageCount:int = 0):ArrayCollection
		{
			
			var arrayCollection:ArrayCollection = new ArrayCollection();
			
			var items:XMLList = xml.descendants("item");
			
			var index:int = 0;
			for each(var item:XML in items)
			{
				var thumbImgUrl:String = "";
				var ranking:int = (++index) + (100*0);
				var videoName:String = "";
				var videoInfo:String = "";
				var condition:String = "";
				var downloadedItemUrl:String = "";
				var nicoVideoUrl:String = item.link.text();
				
				
				var array:Array = NicoPattern.myListThumbImgUrlPattern.exec(item.description.text());
				if(array != null && array.length >= 1){
					thumbImgUrl = array[1];
				}
				
				var title:String = item.title.text();
				try{
//					title = decodeURIComponent(title);
					title = HtmlUtil.convertSpecialCharacterNotIncludedString(title);
				}catch(error:Error){
					trace(error);
				}
				var length:String = "";
				array = null;
				array = NicoPattern.myListLength.exec(item.description.text());
				if(array != null && array.length >= 1){
					length = "    再生時間 " + array[1];
				}
				var date:String = "";
				array = null;
				array = NicoPattern.myListInfoDate.exec(item.description.text());
				if(array != null && array.length >= 1){
					date = "    投稿日時 " + array[1];
				}
				
				var videoId:String = PathMaker.getVideoID(nicoVideoUrl);
				var libraryManager:ILibraryManager = LibraryManagerBuilder.instance.libraryManager;
				var nnddVideo:NNDDVideo = libraryManager.isExistByVideoId(videoId);
				
				if (nnddVideo != null)
				{
					condition = "動画保存済み\n右クリックから再生できます。";
					downloadedItemUrl = nnddVideo.getDecodeUrl();
				}
				
				arrayCollection.addItem({
					dataGridColumn_preview: thumbImgUrl,
					dataGridColumn_ranking: ranking,
					dataGridColumn_videoName: title + "\n" + length + "\n" + date,
					dataGridColumn_videoInfo: "...取得中",
					dataGridColumn_condition: condition,
					dataGridColumn_downloadedItemUrl: downloadedItemUrl,
					dataGridColumn_nicoVideoUrl: nicoVideoUrl
				});
				
				getThumbInfoAsync(videoId, arrayCollection, arrayCollection.length - 1);
				
			}
			
			return arrayCollection;
		}
		
		/**
		 * 
		 * @param videoId
		 * @param arrayCollection
		 * @param index
		 * 
		 */
		private function getThumbInfoAsync(videoId:String, arrayCollection:ArrayCollection, index:int):void
		{
			var thumbInfoLoader:ThumbInfoLoader = new ThumbInfoLoader();
			
			thumbInfoLoader.addEventListener(ThumbInfoLoader.FAIL, function(event:Event):void{
				if (arrayCollection == null)
				{
					return;
				}
				
				var videoStatus:String = "サムネイル情報の取得に失敗";
				
				if (arrayCollection.length > index && arrayCollection[index].dataGridColumn_nicoVideoUrl.indexOf(videoId) != -1)
				{
					arrayCollection.setItemAt({
						dataGridColumn_preview: arrayCollection[index].dataGridColumn_preview,
						dataGridColumn_ranking: arrayCollection[index].dataGridColumn_ranking,
						dataGridColumn_videoName: arrayCollection[index].dataGridColumn_videoName,
						dataGridColumn_videoInfo: videoStatus,
						dataGridColumn_condition: arrayCollection[index].dataGridColumn_condition,
						dataGridColumn_downloadedItemUrl:arrayCollection[index].dataGridColumn_downloadedItemUrl,
						dataGridColumn_nicoVideoUrl: arrayCollection[index].dataGridColumn_nicoVideoUrl
					}, index);
				}
				
			});
			
			thumbInfoLoader.addEventListener(ThumbInfoLoader.SUCCESS, function(event:Event):void{
				
				if (arrayCollection == null)
				{
					return;
				}
				
				var loader:ThumbInfoLoader = (event.currentTarget as ThumbInfoLoader);
				
				var videoStatus:String = "";
				var thumbInfoAnalyzer:ThumbInfoAnalyzer = new ThumbInfoAnalyzer(new XML(loader.thumbInfo));
				
				if (thumbInfoAnalyzer == null)
				{
					videoStatus = "サムネイル情報の取得に失敗";
				}
				else if (thumbInfoAnalyzer.errorCode != null)
				{
					videoStatus = Message.L_VIDEO_DELETED;
				}
				else
				{
					videoStatus = "再生:" + NumberUtil.addComma(String(thumbInfoAnalyzer.viewCounter)) +
						" コメント:" + NumberUtil.addComma(String(thumbInfoAnalyzer.commentNum)) +
						"\nマイリスト:" + NumberUtil.addComma(String(thumbInfoAnalyzer.myListNum)) +
						"\n" + thumbInfoAnalyzer.lastResBody;
				}
				
				if (arrayCollection.length > index && arrayCollection[index].dataGridColumn_nicoVideoUrl.indexOf(videoId) != -1)
				{
					arrayCollection.setItemAt({
						dataGridColumn_preview: arrayCollection[index].dataGridColumn_preview,
						dataGridColumn_ranking: arrayCollection[index].dataGridColumn_ranking,
						dataGridColumn_videoName: arrayCollection[index].dataGridColumn_videoName,
						dataGridColumn_videoInfo: videoStatus,
						dataGridColumn_condition: arrayCollection[index].dataGridColumn_condition,
						dataGridColumn_downloadedItemUrl:arrayCollection[index].dataGridColumn_downloadedItemUrl,
						dataGridColumn_nicoVideoUrl: arrayCollection[index].dataGridColumn_nicoVideoUrl
					}, index);
				}
			});
			
			thumbInfoLoader.getThumbInfo(videoId);
			
		}
		
		
		
		/**
		 * カテゴリの一覧を返します。
		 * 
		 * @return 
		 * 
		 */
		public static function getCategoryList():Array
		{
			var catList:Array = new Array();
			
			var file:File = File.applicationStorageDirectory.resolvePath(CATEGORY_LIST_FILE_NAME);
			
			var defCategoryList:File = File.applicationDirectory.resolvePath(CATEGORY_LIST_FILE_NAME);
			if (!file.exists)
			{
				defCategoryList.copyTo(file);
			}
			
			var fileIO:FileIO = new FileIO();
			var categoryListXml:XML = fileIO.loadXMLSync(file.nativePath, true);
			
			if (categoryListXml.@version != null && CATEGORY_VERSION != categoryListXml.@version.toString())
			{
				// カテゴリバージョンが違うならバックアップして強制的に上書き
				file.copyTo(File.applicationStorageDirectory.resolvePath(CATEGORY_LIST_FILE_NAME + ".back"), true);
				file.deleteFile();
				defCategoryList.copyTo(file, true);
			}
			
			var categories:XMLList = categoryListXml.category;
			
			for each(var category:XML in categories)
			{
				var title:String = category.@title;
				var suffix:String = category.@suffix;
				catList.push(new Array(title, suffix));
			
				var subCategories:XMLList = category.category;
				
				for each(var subCategory:XML in subCategories)
				{
					title = "  " +  subCategory.@title;
					suffix = subCategory.@suffix;
					catList.push(new Array(title, suffix));
				}
				
			}
			
			return catList;
		}
		
	}
}