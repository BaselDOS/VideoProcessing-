warning('off');
videoReader=vision.VideoFileReader('visionface.avi');
videoPlayer=vision.VideoPlayer;

while( ~isDone(videoReader))
    frame=step(videoReader);
    step(videoPlayer,frame);
end
release(videoPlayer);
release(videoReader);