function septica()
fig = uifigure('Name', 'Pachet de cărți',Color='#6D002A');
fig.Position(3:4) = [800 600];

numeCarti = {'A', '7', '8', '9', '10', 'j', 'q', 'k'};
semneCarti = {'inima', 'romb', 'trefla', 'frunza'};
imageFolderPath = '/Users/elizastergarel/Desktop/septica/';
pachet = struct('nume', '', 'semn', '', 'inJoc', true, 'imagine', '');
spate=imread('/Users/elizastergarel/Desktop/septica/spate.png');
index = 1;
taiat=false;
primaTura=true;
indiceCarteCentru=[];
for s = 1:length(semneCarti)
    for n = 1:length(numeCarti)
        pachet(index).nume = numeCarti{n};
        pachet(index).semn = semneCarti{s};
        pachet(index).inPachet = true;
        index = index + 1;
    end
end

for index = 1:length(pachet)
        numeCarte = pachet(index).nume;
        semnCarte = pachet(index).semn;

        if any(strcmp(numeCarti, numeCarte)) && any(strcmp(semneCarti, semnCarte))
            imageName = [numeCarte '_' lower(semnCarte) '.png'];
            imagePath = fullfile(imageFolderPath, imageName);
            pachet(index).imagine = imagePath;
        end
end

cardButtonStates = false(1, 4);
cartiInMana = cell(1, 4);
cardButtons = cell(1, 4);
cardButtonStatesBot = false(1, 4);
cartiInManaBot = cell(1, 4);
cardButtonsBot = cell(1, 4);
puncteJucator=0;
primaCarte=true;
puncte=0;
puncteBot=0;
rand=1;
cineIaCartile=1;
cartInPachet=32;
carteDeTaiat='7';
global tipCarteCentru;
global numarCarteCentru;

startButton = uibutton(fig, 'push', 'Text', 'Start', 'Position', [425, 20, 100, 30], 'ButtonPushedFcn', @generateRandomHand);
drawButton = uibutton(fig, 'push', 'Text', 'Take', 'Position', [275, 20, 100, 30], 'ButtonPushedFcn', @takeCard);

function generateRandomHand(~, ~)
    availableIndices = find([pachet.inPachet]); 
    indicesToDraw = randsample(availableIndices, 4);

    
    for i = 1:4
        cartiInMana{i} = pachet(indicesToDraw(i));
        createCard(indicesToDraw(i)); 
        pachet(indicesToDraw(i)).inPachet = false;
        
    end

           
            
            availableIndices = find([pachet.inPachet]); 
            indicesToDraw = randsample(availableIndices, 4);
            
            
            for i = 1:4
                cartiInManaBot{i} = pachet(indicesToDraw(i));
                createCardBot(indicesToDraw(i)); 
                pachet(indicesToDraw(i)).inPachet = false;
                
            end
           
end
function createCardBot(cardIndex)
            card = pachet(cardIndex);
            if isempty(card)
                return;
            end
            if(pachet(cardIndex).inPachet==false)
                return;
            end
            
            cardWidth = 80;
            cardHeight = 120;
            startPosX = (fig.Position(3) - 6 * cardWidth) ;
            startPosY = 480;
            
            
            emptyPositions = find(~cardButtonStatesBot);
            firstEmptyPosition = emptyPositions(1); 
            
            img = spate;
            cardButtonsBot{firstEmptyPosition} = uibutton(fig, 'push', 'Icon', img, 'Text', '', ...
                'Position', [startPosX + (firstEmptyPosition - 2) * cardWidth, startPosY, cardWidth, cardHeight]);
            
            cardButtonStatesBot(firstEmptyPosition) = true; 
            cartiInManaBot{firstEmptyPosition} = card; 
            pachet(cardIndex).inPachet=false;
            
            
        end
function createCardCentered(cardIndex)
    card = pachet(cardIndex);
    if isempty(card)
        return;
    end
    indiceCarteCentru = [indiceCarteCentru, cardIndex];
    tipCarteCentru = card.nume;
    numarCarteCentru = card.semn;
    if strcmp(card.nume, 'A') || strcmp(card.nume, '10')
        puncte=puncte+1;
    end
    if primaCarte==true
        carteDeTaiat=card.nume;
        primaCarte=false;
    end
    cardWidth = 80;
    cardHeight = 120;
    figWidth = fig.Position(3);
    figHeight = fig.Position(4);
    startPosX = (figWidth - cardWidth) / 2;
    startPosY = (figHeight - cardHeight) / 2;
    
    img = imread(card.imagine);
    cardButtons{cardIndex} = uibutton(fig, 'push', 'Icon', img, 'Text', '', ...
        'Position', [startPosX, startPosY, cardWidth, cardHeight]);
    cartInPachet=cartInPachet-1;
    disp(cartInPachet);
end
function createCard(cardIndex)
    card = pachet(cardIndex);
    if isempty(card)
        return;
    end
    if(pachet(cardIndex).inPachet==false)
        return;
    end
    
    cardWidth = 80;
    cardHeight = 120;
    startPosX = (fig.Position(3) - 6 * cardWidth) ;
    startPosY = 80;
    
    
    emptyPositions = find(~cardButtonStates);
    firstEmptyPosition = emptyPositions(1); 
    
    img = imread(card.imagine);
    cardButtons{firstEmptyPosition} = uibutton(fig, 'push', 'Icon', img, 'Text', '', ...
        'Position', [startPosX + (firstEmptyPosition - 2) * cardWidth, startPosY, cardWidth, cardHeight], ...
        'ButtonPushedFcn', @(src, event) removeCard(src,cardIndex, firstEmptyPosition));
    
    cardButtonStates(firstEmptyPosition) = true; 
    cartiInMana{firstEmptyPosition} = card; 
    pachet(cardIndex).inPachet=false;

    disp(cardButtonStates);
end
function drawSingleCard()
    availableIndices = find([pachet.inPachet]); 
    
    emptyPositions = find(~cardButtonStates, 1);

    if isempty(availableIndices==false)
        disp('Nu mai sunt cărți disponibile în pachet.');
        return;
    end
    
    if isempty(emptyPositions)
        disp('No empty positions available.');
        return;
    end
    randomIndex = randsample(availableIndices, 1);
    createCard(randomIndex);
    
end
function drawSingleCardBot()
            availableIndices = find([pachet.inPachet]); 
            
            
            emptyPositions = find(~cardButtonStatesBot, 1);
            
            if isempty(availableIndices==false)
                disp('Nu mai sunt cărți disponibile în pachet.');
                return;
            end
            
            if isempty(emptyPositions)
                disp('No empty positions available.');
                return;
            end
            
            randomIndex = randsample(availableIndices, 1);
            createCardBot(randomIndex);
        end
function clearCenterCards()
    
    
    for i = 1:length(indiceCarteCentru)
            indice = indiceCarteCentru(i);
            if ~isempty(cardButtons{indice})
                delete(cardButtons{indice});
            end
    end
     indiceCarteCentru = [];
   
end
function takeCard(~, ~)
    primaTura=true;
    if cartInPachet==0
           if puncteBot==puncteJucator
               disp('egalitate');
               close(fig);
           elseif puncteJucator>puncteBot
               disp('ai castigat');
               close(fig);
           elseif puncteJucator<puncteBot
               disp('ai pierdut'); 
               close(fig);
           end
    end
        if cineIaCartile==1
            disp('eu iau cartile');
            puncteJucator=puncteJucator+puncte;
            puncte=0;
            pause(1);
            clearCenterCards();
            primaCarte=true;
        else
            disp('botul ia cartile');
            puncteBot=puncteBot+puncte;
            puncte=0;
            pause(1);
            clearCenterCards();
            primaCarte=true;
            
        end
        pause(1);
        for i=1:4
            if cardButtonStates(i)==false && cartInPachet>=1
                drawSingleCardBot();
                drawSingleCard();
            end
        end
        if cineIaCartile==2
             removeCardBot();
        end
        

    end
function removeCardBot()
pause(2);
        for i = 1:numel(cartiInManaBot)
             if ~isempty(cartiInManaBot{i})
                 cardBot=cartiInManaBot{i};
                 
                 for j = 1:numel(cartiInManaBot)
                     if ~isempty(cartiInManaBot{j})
                         cardBot2=cartiInManaBot{j};
                      if strcmp(cardBot2.nume, carteDeTaiat) || strcmp(cardBot2.nume, '7')
                        cardBot=cartiInManaBot{i};
                        break;
                      end
                     end
                 end
               
                 for j = 1:numel(pachet)
                       if strcmp(pachet(j).nume, cardBot.nume) && strcmp(pachet(j).semn, cardBot.semn)
                          cardIndexBot= j;
                          break;
                       end
                 end
                  if strcmp(cardBot.nume, '7') || strcmp(cardBot.nume, carteDeTaiat)
                        cineIaCartile=2;
                  end
                  delete(cardButtonsBot{i});
                  createCardCentered(cardIndexBot);
                  cardButtonStatesBot(i) = false;
                  cartiInManaBot{i} = [];
                  return;
             end
        end
    end
function removeCard(~, cardIndex,buttonIndex)
   card=pachet(cardIndex);
            if primaTura==false && ~(strcmp(card.nume, '7')|| strcmp(card.nume, carteDeTaiat))
                return;
            end
            
                delete(cardButtons{buttonIndex});
                createCardCentered(cardIndex);
                cardButtonStates(buttonIndex) = false;
                cartiInMana{buttonIndex} = [];
            if cineIaCartile==2  && (strcmp(card.nume, '7')|| strcmp(card.nume, carteDeTaiat))
                 taiat=true;
            end
            if strcmp(card.nume, '7') || strcmp(card.nume, carteDeTaiat)
                primaTura=false;
                cineIaCartile=1;
               
            end
            if taiat==true
                taiat=false;
                return;
            end
            if cineIaCartile==1 && primaTura==false
                 removeCardBot();
                 primaTura=false;
            end
        disp(puncte);  
end
end