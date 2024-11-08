// @ts-nocheck
Cheat.GetFixedUsername = function() {
	var NewUsername = '';
	const Username = Cheat.GetUsername();
	for (var i = 0; i < Username.length; i++) {
		const Char = Username[i];
		if (Char >= 'а' && Char <= 'я') {
			NewUsername += '?';
			continue;
		}

		NewUsername += Char;
	}

	return NewUsername;
};

String.prototype.format = function() {
	var Args = arguments;
	return this.replace(/{(\d+)}/g, function(Match, Index) {
		return typeof Args[Index] != 'undefined' ? Args[Index] : Match;
	});
};

Cheat.Log = function(Text, AltColor) {
	if (typeof(Text) != 'string') {
		Text = Text.toString();
	}
	
	var Color = Context.Colors.MainLogColor;
	if (AltColor) {
		Color = Context.Colors.MainAltLogColor;
	}

	Cheat.PrintColor([Color[0], Color[1], Color[2], 255], '[{0}] '.format(Context.Label.toLowerCase())), Cheat.PrintColor([255, 255, 255, 255], Text);
};

String.prototype.splitIntoChunks = function(ChunkSize) {
	const Chunks = Math.ceil(this.length / ChunkSize);
	const Result = new Array(Chunks);
	for (var i = 0, o = 0; i < Chunks; ++i, o += ChunkSize) {
		Result[i] = this.substr(o, ChunkSize);
	}
	return Result;
}

Render.ShadowStringCustom = function(X, Y, Align, Text, Color, Font, ShadowWidth) {
	Render.StringCustom(X + ShadowWidth, Y + ShadowWidth, Align, Text, [0, 0, 0, Color[3]], Font);
	Render.StringCustom(X, Y, Align, Text, Color, Font);
}

Render.OutlineString = function(X, Y, Align, Text, Color, Font) {
	Render.StringCustom(X - 1, Y - 1, Align, Text, [0, 0, 0, Color[3]], Font);
	Render.StringCustom(X - 1, Y, Align, Text, [0, 0, 0, Color[3]], Font);
	Render.StringCustom(X - 1, Y + 1, Align, Text, [0, 0, 0, Color[3]], Font);
	Render.StringCustom(X, Y + 1, Align, Text, [0, 0, 0, Color[3]], Font);
	Render.StringCustom(X, Y - 1, Align, Text, [0, 0, 0, Color[3]], Font);
	Render.StringCustom(X + 1, Y - 1, Align, Text, [0, 0, 0, Color[3]], Font);
	Render.StringCustom(X + 1, Y, Align, Text, [0, 0, 0, Color[3]], Font);
	Render.StringCustom(X + 1, Y + 1, Align, Text, [0, 0, 0, Color[3]], Font);
	Render.StringCustom(X, Y, Align, Text, Color, Font);
}

Render.RectOutline = function(X, Y, W, H, Color){
	Render.Rect(X, Y + 0.2, W, H, Color);
	Render.Rect(X + 0.2, Y, W, H, Color);
}

Render.FadedString = function(X, Y, Align, Text, Speed, AlphaModif, Color, SecondColor, Font, Type) {
	if (Type == 1){
		Render.StringCustom(X + .1, Y, Align, Text, SecondColor, Font);
	} else if (Type == 2) {
		Render.ShadowStringCustom(X + .1, Y, Align, Text, SecondColor, Font, 1);
	} else if (Type == 3) {
		Render.OutlineString(X + .1, Y, Align, Text, SecondColor, Font);
	}

	const Tickcount = Context.Globals.Tickcount * Speed;
	
	const AlphaModifier = AlphaModif / Text.length;
	var Scoped = 0;
	
	for (var i = 0; i < Text.length; i++) {
		const Char = Text[i];
		const AlphaX2 = (Tickcount - i * AlphaModifier) % 800;
		const Alpha = AlphaX2 > 255 ? 510 - AlphaX2 : AlphaX2;

		if (Alpha >= 1) {
			Render.StringCustom(X + Scoped, Y, 0, Char, [Color[0], Color[1], Color[2], Alpha], Font);
		}

		Scoped += Render.TextSizeCustom(Char, Font)[0];
	}
}

Math.Random = function(Min, Max) {
	Min = Math.ceil(Min);
	Max = Math.floor(Max);
	return Math.floor(Math.random() * (Max - Min + 1)) + Min;
}

function Vector(Initializator) {
	const InitValue = [0, 0, 0];
	
	if (Initializator) {
		if (arguments.length == 3 && typeof(arguments[0]) == 'number') {
			InitValue[0] = arguments[0];
			InitValue[1] = arguments[1];
			InitValue[2] = arguments[2];
		}
	
		if (typeof(Initializator) == 'object') {
			if (Array.isArray(Initializator) && Initializator.length > 0) {
				const Length = Initializator.length;
		
				if (Length == 3) {
					InitValue[0] = Initializator[0];
					InitValue[1] = Initializator[1];
					InitValue[2] = Initializator[2];
				}
		
				if (Length == 2) {
					InitValue[0] = Initializator[0];
					InitValue[1] = Initializator[1];
				}
				
				if (Length == 1) {
					InitValue[0] = Initializator[0];
				}
			} else {
				if ('X' in Initializator) {
					InitValue[0] = Initializator.X;
				}
		
				if ('Y' in Initializator) {
					InitValue[1] = Initializator.Y;
				}
		
				if ('Z' in Initializator) {
					InitValue[2] = Initializator.Z;
				}
			}
		}
	}

	return {
		X: InitValue[0],
		Y: InitValue[1],
		Z: InitValue[2],
		Add: function(Other) {
			if (!Other || typeof(Other) != 'object') {
				return this;
			}

			if (Array.isArray(Other)) {
				const Length = Other.length;

				if (Length == 3) {
					return (this.X += Other[0], this.Y += Other[1], this.Z += Other[2], this);
				}

				if (Length == 2) {
					return (this.X += Other[0], this.Y += Other[1], this);
				}
				
				if (Length == 1) {
					return (this.X += Other[0], this);
				}

				return this;
			}


			if ('X' in Other) {
				this.X += Other.X;
			}

			if ('Y' in Other) {
				this.Y += Other.Y;
			}

			if ('Z' in Other) {
				this.Z += Other.Z;
			}

			return this;
		},
		Sub: function(Other) {
			if (!Other || typeof(Other) != 'object') {
				return this;
			}

			if (Array.isArray(Other)) {
				const Length = Other.length;

				if (Length == 3) {
					return (this.X -= Other[0], this.Y -= Other[1], this.Z -= Other[2], this);
				}

				if (Length == 2) {
					return (this.X -= Other[0], this.Y -= Other[1], this);
				}
				
				if (Length == 1) {
					return (this.X -= Other[0], this);
				}

				return this;
			}

			if ('X' in Other) {
				this.X -= Other.X;
			}

			if ('Y' in Other) {
				this.Y -= Other.Y;
			}

			if ('Z' in Other) {
				this.Z -= Other.Z;
			}

			return this;
		},
		SubAlt: function(Other) {
			if (!Other || typeof(Other) != 'object') {
				return this;
			}

			if (Array.isArray(Other)) {
				const Length = Other.length;

				if (Length == 3) {
					return (this.X -= Other[0], this.Y -= Other[1], this.Z = (Other[2] - this.Z), this);
				}

				if (Length == 2) {
					return (this.X -= Other[0], this.Y -= Other[1], this);
				}
				
				if (Length == 1) {
					return (this.X -= Other[0], this);
				}

				return this;
			}

			if ('X' in Other) {
				this.X -= Other.X;
			}

			if ('Y' in Other) {
				this.Y -= Other.Y;
			}

			if ('Z' in Other) {
				this.Z = Other.Z - this.Z;
			}

			return this;
		},
		Mul: function(Other) {
			if (!Other || typeof(Other) != 'object') {
				return this;
			}

			if (Array.isArray(Other)) {
				const Length = Other.length;

				if (Length == 3) {
					return (this.X *= Other[0], this.Y *= Other[1], this.Z *= Other[2], this);
				}

				if (Length == 2) {
					return (this.X *= Other[0], this.Y *= Other[1], this);
				}
				
				if (Length == 1) {
					return (this.X *= Other[0], this);
				}

				return this;
			}

			if ('X' in Other) {
				this.X *= Other.X;
			}

			if ('Y' in Other) {
				this.Y *= Other.Y;
			}

			if ('Z' in Other) {
				this.Z *= Other.Z;
			}

			return this;
		},
		Div: function(Other) {
			if (!Other || typeof(Other) != 'object') {
				return this;
			}

			if (Array.isArray(Other)) {
				const Length = Other.length;

				if (Length == 3) {
					return (this.X /= Other[0], this.Y /= Other[1], this.Z /= Other[2], this);
				}

				if (Length == 2) {
					return (this.X /= Other[0], this.Y /= Other[1], this);
				}
				
				if (Length == 1) {
					return (this.X /= Other[0], this);
				}

				return this;
			}

			if ('X' in Other) {
				this.X /= Other.X;
			}

			if ('Y' in Other) {
				this.Y /= Other.Y;
			}

			if ('Z' in Other) {
				this.Z /= Other.Z;
			}

			return this;
		},
		Length2D: function() {
			return Math.sqrt(this.X * this.X + this.Y * this.Y);
		},
		Length2DSqr: function() {
			return this.X * this.X + this.Y * this.Y;
		},
		Length: function() {
			return Math.sqrt(this.X * this.X + this.Y * this.Y + this.Z * this.Z);
		},
		LengthSqr: function() {
			return this.X * this.X + this.Y * this.Y + this.Z * this.Z;
		},
		ToArray: function() {
			return [this.X, this.Y, this.Z];
		},
		Copy: function() {
			return Vector(this.X, this.Y, this.Z);
		},
		Format: function(Precision) {
			Precision = Precision ? Precision : 1;
			return 'X: ' + this.X.toFixed(Precision) + ' Y: ' + this.Y.toFixed(Precision) + ' Z: ' + this.Z.toFixed(Precision);
		},
		DistanceTo: function(Other) {
			if (!Other || typeof(Other) != 'object') {
				return this;
			}

			return this.Copy().Sub(Other).Length();
		},
		DistanceTo2D: function(Other) {
			if (!Other || typeof(Other) != 'object') {
				return this;
			}

			return this.Copy().Sub(Other).Length2D();
		},
		DistanceToSqr: function(Other) {
			if (!Other || typeof(Other) != 'object') {
				return this;
			}

			return this.Copy().Sub(Other).LengthSqr();
		},
		DistanceTo2DSqr: function(Other) {
			if (!Other || typeof(Other) != 'object') {
				return this;
			}

			return this.Copy().Sub(Other).Length2DSqr();
		},
	};
}

const ui = { Elements: [] }; {
	ui.AddRef = function(Ref, ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues) {
		this.Elements.push({ Ref: Ref, ConditionRefs: ConditionRefs, ConditionValues: ConditionValues, SecondConditionRefs: SecondConditionRefs, SecondConditionValues: SecondConditionValues, DropdownRefs: DropdownRefs, DropdownValues: DropdownValues });
		return Ref;
	},

	ui.AddLabel = function(Name, ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues) {
		UI.AddLabel(Name);
		return ui.AddRef([Name], ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues);
	},

	ui.AddSliderInt = function(Name, Min, Max, DefaultValue, ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues) {
		UI.AddSliderInt(Name, Min, Max);
		UI.SetValue("Script items", Name, DefaultValue);
		return ui.AddRef(['Script items', Name], ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues);
	},

	ui.AddSliderFloat = function(Name, Min, Max, DefaultValue, ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues) {
		UI.AddSliderFloat(Name, Min, Max);
		UI.SetValue("Script items", Name, DefaultValue);
		return ui.AddRef(['Script items', Name], ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues);
	},

	ui.AddHotkey = function(Name, ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues) {
		UI.AddHotkey(Name);
		return ui.AddRef(['Script items', Name], ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues);
	},

	ui.AddCheckbox = function(Name, ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues) {
		UI.AddCheckbox(Name);
		return ui.AddRef(['Script items', Name], ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues);
	},

	ui.AddDropdown = function(Name, Elements, ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues) {
		UI.AddDropdown(Name, Elements);
		return ui.AddRef(['Script items', Name], ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues);
	},

	ui.AddMultiDropdown = function(Name, Elements, ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues) {
		UI.AddMultiDropdown(Name, Elements);
		return ui.AddRef(['Script items', Name], ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues);
	},

	ui.AddColorPicker = function(Name, Color, ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues) {
		UI.AddColorPicker(Name);
		UI.SetColor('Script items', Name, Color);
		
		return ui.AddRef(['Script items', Name], ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues);
	},

	ui.AddTextbox = function(Name, ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues) {
		UI.AddTextbox(Name);
		return ui.AddRef(['Script items', Name], ConditionRefs, ConditionValues, SecondConditionRefs, SecondConditionValues, DropdownRefs, DropdownValues);
	},

	ui.GetValue = function(Ref) {
		return UI.GetValue.apply(null, Ref);
	},

	ui.GetMultiDropdown = function(Ref, Index) {
		return ui.GetValue(Ref) & (1 << Index);
	},

	ui.GetDropdown = function(Ref, Index) {
		return ui.GetValue(Ref) & (1 << Index);
	},

	ui.SetValue = function(Ref, Value) {
		return UI.SetValue.apply(null, Ref.concat(Value));
	},

	ui.GetHotkey = function(Ref) {
		return UI.IsHotkeyActive.apply(null, Ref);
	},

	ui.GetColor = function(Ref) {
		return UI.GetColor.apply(null, Ref);
	}

	ui.SetColor = function(Ref) {
		return UI.SetColor.apply(null, Ref);
	}

	ui.ToggleHotkey = function(Ref) {
		UI.ToggleHotkey.apply(null, Ref);
		return ui.GetHotkey(Ref);
	},

	ui.SetHotkey = function(Ref, Value) {
		if (ui.GetHotkey(Ref) != Value) {
			ui.ToggleHotkey(Ref);
		}
	},

	ui.Import = function(Config) {
		const BlackMagic = function(Input) {
			const Rev = function(String, Index) {
				return !(Index % 3) ? String.split('').reverse().join('') : String;
			};
			
			var Result = '';
			for (var i = 0; i < Input.length; i += 3) {
				if (Input[i + 1] && Input[i + 2]) {
					Result += Rev(Input[i] + Input[i + 1] + Input[i + 2], i);
				} else if (Input[i + 1]) {
					Result += Rev(Input[i] + Input[i + 1], i);
				}
			}

			return Result;
		};

		const DecodeBase64 = function(Input) {
			Input = Input.replace(/[^A-Za-z0-9\+\/\=]/g, '');

			const Key = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
			var i = 0, Decoded = '';
			while (i < Input.length) {
				const Encrypted1 = Key.indexOf(Input.charAt(i++));
				const Encrypted2 = Key.indexOf(Input.charAt(i++));
				const Encrypted3 = Key.indexOf(Input.charAt(i++));
				const Encrypted4 = Key.indexOf(Input.charAt(i++));
	
				const Char1 = (Encrypted1 << 2) | (Encrypted2 >> 4);
				const Char2 = ((Encrypted2 & 15) << 4) | (Encrypted3 >> 2);
				const Char3 = ((Encrypted3 & 3) << 6) | Encrypted4;
	
				Decoded = Decoded + String.fromCharCode(Char1);
	
				if (Encrypted3 != 64) {
					Decoded = Decoded + String.fromCharCode(Char2);
				}
	
				if (Encrypted4 != 64) {
					Decoded = Decoded + String.fromCharCode(Char3);
				}
			}
	
			i = 0;
			
			var Result = '';
			while (i < Decoded.length) {
				const Char = Decoded.charCodeAt(i);
	
				if (Char < 128) {
					Result += String.fromCharCode(Char);
					i++;
				} else if ((Char > 191) && (Char < 224)) {
					const Char2 = Decoded.charCodeAt(i + 1);
					Result += String.fromCharCode(((Char & 31) << 6) | (Char2 & 63));
					i += 2;
				} else {
					const Char2 = Decoded.charCodeAt(i + 1);
					const Char3 = Decoded.charCodeAt(i + 2);
					Result += String.fromCharCode(((Char & 15) << 12) | ((Char2 & 63) << 6) | (Char3 & 63));
					i += 3;
				}
			}
	
			return Result;
		};
		
		try {
			if (!Config) {
				Cheat.Log('Failed to import: empty config or addon not loaded\n', true);
                AddToEventLog([{Text: 'Failed to import: empty config or addon not loaded'}], 3);
                return;
			}

			const Elements = JSON.parse(DecodeBase64(Config)).Elements;
			for (var i = 0; i < Elements.length; i++) {
				const Element = Elements[i];
				if (!Element) {
					continue;
				}
				
				if (Array.isArray(Element.value)) {
					UI.SetColor(Element.ref[0], Element.ref[1], Element.value);
					continue;
				}

				ui.SetValue(Element.ref, Element.value);
			}

			Cheat.Log('Successfully imported config\n');
			AddToEventLog([{ Text: 'Successfully imported config' }], 3);
			
			return JSON.stringify(Elements);
		} catch (Error) {
			Cheat.Log('Failed to load cfg: {0}\n'.format(Error), true);
			AddToEventLog([{Text: 'Failed to load cfg: {0}\n'.format(Error) }], 3);
		}

		return '';
	},

	ui.Export = function() {
		const BlackMagic = function(Input) {
			const Rev = function(String, Index) {
				return !(Index % 3) ? String.split('').reverse().join('') : String;
			};
			
			var Result = '';
			for (var i = 0; i < Input.length; i += 3) {
				if (Input[i + 1] && Input[i + 2]) {
					Result += Rev(Input[i] + Input[i + 1] + Input[i + 2], i);
				} else if (Input[i + 1]) {
					Result += Rev(Input[i] + Input[i + 1], i);
				}
			}

			return Result;
		};

		const EncodeBase64 = function(Input) {
			Input = Input.replace(/\r\n/g, '\n');
			var Fixed = '';
	
			for (var n = 0; n < Input.length; n++) {
				var Char = Input.charCodeAt(n);
	
				if (Char < 128) {
					Fixed += String.fromCharCode(Char);
				}
				else if((Char > 127) && (Char < 2048)) {
					Fixed += String.fromCharCode((Char >> 6) | 192);
					Fixed += String.fromCharCode((Char & 63) | 128);
				}
				else {
					Fixed += String.fromCharCode((Char >> 12) | 224);
					Fixed += String.fromCharCode(((Char >> 6) & 63) | 128);
					Fixed += String.fromCharCode((Char & 63) | 128);
				}
			}
	
			const Key = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';

			var Char = 0, Result = '';
			while (Char < Fixed.length) {
				const Char1 = Fixed.charCodeAt(Char++);
				const Char2 = Fixed.charCodeAt(Char++);
				const Char3 = Fixed.charCodeAt(Char++);
	
				const Encrypted1 = Char1 >> 2;
				const Encrypted2 = ((Char1 & 3) << 4) | (Char2 >> 4);
				const Encrypted3 = ((Char2 & 15) << 2) | (Char3 >> 6);
				const Encrypted4 = Char3 & 63;
	
				Result = Result + Key.charAt(Encrypted1) + Key.charAt(Encrypted2) + Key.charAt(isNaN(Char2) ? 64 : Encrypted3) + Key.charAt(isNaN(Char3) ? 64 : Encrypted4);
			}
	
			return Result;
		};
		
		const JSONObj = { Elements: [] };
		for (var i = 0; i < ui.Elements.length; i++) {
			const Element = ui.Elements[i];
			if (!Element) {
				continue;
			}
			
			if (Array.isArray(Element.Ref) && (Element.Ref[Element.Ref.length - 1] == ConfigImport[ConfigImport.length - 1] || Element.Ref[Element.Ref.length - 1] == ConfigExport[ConfigExport.length - 1] || Element.Ref[Element.Ref.length - 1] == 'cynosa modulations')) {
				continue;
			}
		
			const Color = ui.GetColor(Element.Ref);
			const Value = ui.GetValue(Element.Ref);
			const IsColor = !!Color && !Value;
		
			JSONObj.Elements[JSONObj.Elements.length] = { ref: Element.Ref, value: IsColor ? Color : Value };
		}

		const EncodedCfg = EncodeBase64(JSON.stringify(JSONObj));
		const Chunks = EncodedCfg.splitIntoChunks(50);
		for (var i = 0; i < Chunks.length; i++) {
			Cheat.Print(Chunks[i]);
		}
		Cheat.Print('\n');
		
		return EncodedCfg;
	},

	ui.Update = function() {
		if (!UI.IsMenuOpen()) {
			return;
		}

		for (i in ui.Elements) {
			const Element = ui.Elements[i];
			var Enabled = true;
			for (j in Element.ConditionRefs) {
				if (ui.GetValue(Element.ConditionRefs[j]) != Element.ConditionValues[j]) {
					Enabled = false;
					break;
				}
			}
			
			for (j in Element.SecondConditionRefs) {
				if (ui.GetValue(Element.SecondConditionRefs[j]) < Element.SecondConditionValues[j]) {
					Enabled = false;
					break;
				}
			}

			for (j in Element.DropdownRefs) {
                if (!ui.GetDropdown(Element.DropdownRefs[j], Element.DropdownValues[j])) {
                    Enabled = false;
                    break;
                }
            }

			try {
				UI.SetEnabled(Element.Ref[Element.Ref.length - 1], Enabled);
			} catch (_) {
				UI.SetEnabled(Element.Ref, Enabled);
			}
		}	
	}
};

const Refs = {
	Rage: {
		Ragebot: ['Rage', 'GENERAL', 'General', 'Enabled'],
		Hideshots: ['Rage', 'GENERAL', 'Exploits', 'Hide shots'],
		Doubletap: ['Rage', 'GENERAL', 'Exploits', 'Doubletap'],
		Autoscope: ['Rage', 'GENERAL', 'General', 'Auto scope'],
		ForceSafe: ['Rage', 'GENERAL', 'General', 'Force safe points'],
		ForceBaim: ['Rage', 'GENERAL', 'General', 'Force body aim'],
	},
	Visual: {
		Thirdperson: ['Visual', 'WORLD', 'View', 'Thirdperson'],
		ScopeBlend: ['Visual', 'SELF', 'Chams', 'Scope Blend'],
		VisibleType: ['Visual', 'SELF', 'Chams', 'Visible type'],
		VisibleOverride: ['Visual', 'SELF', 'Chams', 'Visible override'],
		VisibleTransparency: ['Visual', 'SELF', 'Chams', 'Visible transparency'],
	},
	AntiAim: {
		Enabled: ['Anti-Aim', 'Rage Anti-Aim', 'Enabled'],
		ManualDir: ['Anti-Aim', 'Rage Anti-Aim', 'Manual Dir'],
		AtTargets: ['Anti-Aim', 'Rage Anti-Aim', 'At targets'],
		AutoDirection: ['Anti-Aim', 'Rage Anti-Aim', 'Auto direction'],
		Yaw: ['Anti-Aim', 'Rage Anti-Aim', 'Yaw offset'],
		JitterOffset: ['Anti-Aim', 'Rage Anti-Aim', 'Jitter offset'],
		FakeAngles: ['Anti-Aim', 'Fake angles', 'Enabled'],
		LbyMode: ['Anti-Aim', 'Fake angles', 'LBY mode'],
		DesyncOnShot: ['Anti-Aim', 'Fake angles', 'Desync on shot'],
		AvoidOverlap: ['Anti-Aim', 'Fake angles', 'Avoid overlap'],
		HideRealAngle: ['Anti-Aim', 'Fake angles', 'Hide real angle'],
		Inverter: ['Anti-Aim', 'Fake angles', 'Inverter'],
		Pitch: ['Anti-Aim', 'Extra', 'Pitch'],
		Fakeduck: ['Anti-Aim', 'Extra', 'Fake duck'],
		Slowwalk: ['Anti-Aim', 'Extra', 'Slow walk'],
		JitterMove: ['Anti-Aim', 'Extra', 'Jitter move'],
		InverterFlip: ['Anti-Aim', 'Fake angles', 'Inverter flip'],
	},
	Fakelag: {
		Enabled: ['Anti-Aim', 'Fake-Lag', 'Enabled'],
		Limit: ['Anti-Aim', 'Fake-Lag', 'Limit'],
		Jitter: ['Anti-Aim', 'Fake-Lag', 'Jitter'],
		Triggers: ['Anti-Aim', 'Fake-Lag', 'Triggers'],
		TriggerLimit: ['Anti-Aim', 'Fake-Lag', 'Trigger limit'],
	},
	Misc: {
		BuyBot: ['Misc', 'GENERAL', 'Buybot', 'Enable'],
		EdgeJump: ['Misc', 'GENERAL', 'Movement', 'Edge jump'],
		Autopeek: ['Misc', 'GENERAL', 'Movement', 'Auto peek'],
		Slidewalk: ['Misc', 'GENERAL', 'Movement', 'Slide walk'],
		TurnSpeed: ['Misc', 'GENERAL', 'Movement', 'Turn speed'],
		ExtendedBacktrack: ['Misc', 'GENERAL', 'Miscellaneous', 'Extended backtracking'],
		ForceSVCheats: ['Misc', 'GENERAL', 'Miscellaneous', 'Force sv_cheats'],
		Restrictions: ['Misc', 'PERFORMANCE & INFORMATION', 'Information', 'Restrictions'],
	},
	Script: {
		Rage: {
			PingSpike: ['Script items', 'Ping spike'],
			Hitchance: ['Script items', 'Hitchance Override'],
			MinimumDamage: ['Script items', 'Minimum damage'],
			DormantAimbot: ['Script items', 'Dormant aimbot'],
		},
		AntiAim: {
			Legfucker: ['Script items', 'Legbreaker'],
			Freestanding: ['Script items', 'Freestanding'],
			AdaptiveFakelag: ['Script items', 'Adaptive Fake-Lag'],
			LeftManual: ['Script items', 'Left Manual'],
			RightManual: ['Script items', 'Right Manual'],
			BackwardManual: ['Script items', 'Backward Manual'],
			ForwardManual: ['Script items', 'Forward Manual'],
			AtTargets: [],
			Pitch: [],
			YawType: [],
			Yaw: [],
			YawLeft: [],
			YawRight: [],
			YawJitter: [],
			JitterEnable: [],
			YawModifier	: [],
			YawRange: [],
			YawRandomMin: [],
			YawRandomMax: [],
			YawSpeedSpin: [],
			YawSpin: [],
			YawOffsetSpin: [],
			Options: [],
			InverterFlipTime: [],
			AntiBrute: [],
			AntiBruteType: [],
			DesyncType: [],
			DesyncLimitLeft: [],
			DesyncLimitRight: [],
			DesyncRandomMin: [],
			DesyncRandomMax: [],
		},
		Visual: {
			MainLogColor: ['Script items', 'Main Log color'],
			MainAltLogColor: ['Script items', 'Miss Log color'],
			MainColor: ['Script items', 'Main color'],
			AlternativeColor: ['Script items', 'Alternative color'],
			MainKibitColor: ['Script items', 'Main Kibit color'],
			DMGIndicatorColor: ['Script items', 'DMG indicator color'],
			DMGActiveIndicatorColor: ['Script items', 'Min.DMG indicator color'],
			CrosshairHitmarkerColor: ['Script items', 'Crosshair hitmarker color'],
			AltKibitColor: ['Script items', 'Alternative Kibit color'],
			BulletTracerColor: ['Script items', 'Bullet Tracer color'],
			AspectRatio: ['Script items', 'AspectRatio Value'],
		},
	}
};

const Context = {
	Version	: '2.0.1',
	Build	: 'NIGHTLY',
	Label	: 'CYNOSA',
	Username: Cheat.GetUsername(),
	FixedUsername: Cheat.GetFixedUsername(),
	Players: Entity.GetPlayers(),
	Clantag: {
		LastClantag: '',
		LastTick: -1,
		Restored: false,
	},
	LocalPlayer: {
		Index: Entity.GetLocalPlayer(),
		Weapon: {
			Index: -1,
			Name: '',
			ClassName: '',
			NonAim: false,
			NextAttack: -1,
		},
		Alive	: false,
		CanFire	: false,
		Team	: -1,
		Knife	: false,
		Taser	: false,
		Grenade	: false,
		LastFire: Globals.Curtime(),
		RestoredBuy: false,
		Velocity: -1,
		Money: -1,
		VelocityModifier: -1,
		Velocity2D: -1,
		GroundTicks: -1,
		OnGround: false,
		EyePosition	: Vector(),
		ChokedCommands: -1,
		LastChokedCommands: -1,
		LagComp: {
			Broken: false,
			LastBroken: 0,
			Ticks: 0,
			LastKnownOrigin: Vector(),
		},
		Netvars: {
			GroundEntity: -1,
			NextAttack: -1,
			NextPrimaryAttack: -1,
			Tickbase: -1,
			Scoped: false,
			ResumeZoom: false,
			DuckAmount: -1,
			VecVelocity: Vector(),
			VecViewOffset: Vector(),
			VecOrigin: Vector(),
			EyeAngles: Vector(),
			Ping: -1,
			Defusing: false,
		},
	},
	Rage: {
		AntiPredict: false,
		CurrentWeapon: -1,
		LastDamage:  0, 
		CurrentTab: -1,
		MinimumHitchanc: -1,
		MinimumDamage: -1,
		LastShotTick: -1,
		Target: -1,
		PredictedTarget: -1,
		ClosestTarget: -1,
		ExploitCharge: Exploit.GetCharge(),
		RestoredAttack: false,
		LastShot: {
			Hitchance: -1,
			Hitbox: -1,
			Safe: false,
			Target: -1,
			Exploit: -1,
			Damage: -1,
		},
		ShotData: [],
		Shots: {
			Fired: 0,
			Registered: 0,
		}
	},
	Globals: {
		ServerTime	 : -1,
		FixedRealtime: 0.0,
		Curtime		 : Globals.Curtime(),
		Frametime	 : Globals.Frametime(),
		Framerate	 : Math.round(1 / Globals.Frametime()),
		Realtime	 : Globals.Realtime(),
		TickInterval : Globals.TickInterval(),
		Tickcount	 : Globals.Tickcount(),
		Tickrate	 : Globals.Tickrate(),
		ServerTick	 : Math.round(Globals.Tickcount() + Local.Latency() / Globals.TickInterval()),
	},
	Colors: {
		MainLogColor	: [159, 202, 43, 255],
		MainAltLogColor	: [255, 0, 50, 255],
		MainColor		: [0, 0, 0, 0],
		AlternativeColor: [0, 0, 0, 0],
		MainKibit		: [0, 0, 0, 0],
		DMGColor		: [0, 0, 0, 0],
		DMGActiveColor	: [0, 0, 0, 0],
		CrosshairColor	: [0, 0, 0, 0],
		AltKibit		: [0, 0, 0, 0],
		BulletTracer	: [0, 0, 0, 0],
	},
	Keybinds: {
		Slowwalk		 : false,
		Fakeduck		 : false,
		Doubletap		 : false,
		Hideshots		 : false,
		MinimumDamage	 : false,
		HitchanceOverride: false,
		ForceBaim		 : false,
		ForceSafe		 : false,
		PingSpike		 : false,
		Autopeek		 : false,
		Freestanding	 : false,
		LegitAA			 : false,
		Inverter		 : false,
		DormantAimbot	 : false,
	},
	Animations: {
		Scoped			: SmoothStepAnimation(5),
		NotGrenade		: SmoothStepAnimation(5),
		Freeze			: SmoothStepAnimation(5),
		NotFreeze		: SmoothStepAnimation(5),
		Doubletap		: SmoothStepAnimation(5),
		Hideshots		: SmoothStepAnimation(5),
		MinimumDamage	: SmoothStepAnimation(5),
		ForceBaim		: SmoothStepAnimation(5),
		ForceSafe		: SmoothStepAnimation(5),
		PingSpike		: SmoothStepAnimation(5),
		Freestanding	: SmoothStepAnimation(5),
		DormantAimbot	: SmoothStepAnimation(5),
		Hitchance 		: SmoothStepAnimation(5),
		FakeDuck		: SmoothStepAnimation(5),
		Exploiting		: SmoothStepAnimation(5),
		Hitted			: SmoothStepAnimation(5),
		Dormant			: SmoothStepAnimation(5),
		VelocityModifier: SmoothStepAnimation(5),
		LagComp			: SmoothStepAnimation(5),
		AntiBrute		: SmoothStepAnimation(5),
		SafeHead		: SmoothStepAnimation(5),
		PingColor: 0,
	},
	Visuals: {
		TransparencyGrenadeRestored: false,
		KeepScopeTransparancyRestored: false,
		VisibleTransparencyRestored: ui.GetValue(Refs.Visual.VisibleTransparency),
		LastTransparency: 0,
		LastGrenadeTransparency: 0,
	},
	Fonts: {
		VerdanaBold	: -1,
		VerdanaBold1: -1,
		VerdanaBold2: -1,
		SmallPixel	: -1,
		Calibri		: -1,
		Verdana		: -1,
		VerdanaThin	: -1,
	},
	AntiAim: {
		SilentTick: -1,
		ChokedTick: -1,
		Silent: false,
		RestoredSilent: false,
		State: 0,
		SpinTime: 0,
		RestoredOverride: false,
		AntiBackstab: false,
		SafeHead: false,
		Warmup: false,
		Freeze: false,
		Hitted: false,
		HittedTime: -1,
		AntiBrute: false,
		AntiBruteTime: -1,
		ManualData: {},
		ManualYaw: 0,
		ManualLeft: 1,
		ManualRight: 2,
		ManualBackward: 3,
		ManualForward: 4,
		LastInvertTick: Globals.Tickcount(),
		SwayState: 0,
		States: [
			'General',
			'Stand',
			'Moving',
			'Slowwalk',
			'Crouch T',
			'Crouch CT',
			'Crouch+',
			'Air',
			'Air+',
			'Fakelag',
			'Freestand',
			'Legit AA',
		],
	},
	FakeLag: {
		Backup: ui.GetValue(Refs.Fakelag.Enabled),
		Enabled: 0,
	},
	Logs: [],
	Misc: {
		BackupedThirdperson: ui.GetValue(Refs.Visual.Thirdperson),
		BackupedAspectratio: Convar.GetFloat('r_aspectratio'),
		RestoredAspectratio: false,
		RestoredThirdperson: false,
		LastAspectratio: 0,
	},
	ZeusFire: false,
	GrenadeThrown: false,
	CrosshairLogs: [],
	SpectatorsList: [],
	TrashtalkQueue: [],
    NextAvailableTime: Globals.Curtime(),
    LastPhrases: [],
	Crosshairhitmarker: {
		Time: 0,
		ShouldDraw: false,				
	},
	KibitWorldMarkerData: [],
	LineBulletTracerData: [],
	Addon: {
		Loaded: false,
	}
};

const Addon = require('lib\\lib.js').Addon;
const AddonFunctions = {
	CanUseAddonFunctions: function() {
		return Addon && Addon.IsLoaded && Addon.IsLoaded() && Convar.GetInt('net_graph') > 0; 
	},
	GetClipboard: function() {
		if (!Context.Addon.Loaded || !Addon.GetClipboard) {
			return '';
		}

		return Addon.GetClipboard();
	},
	GetChokedCommands: function() {
		if (!Context.Addon.Loaded || !Addon.GetChokedCommands) {
			if (!World.GetServerString()) {
				return -1;
			}

			const flSimulationTime = Entity.GetProp(Context.LocalPlayer.Index, "CBaseEntity", "m_flSimulationTime");
			const flSimDiff = Globals.Curtime() - flSimulationTime;
			return (Math.ceil(0.5 + Math.max(0, flSimDiff - Local.Latency()) / Globals.TickInterval())) - 1;
		}

		return parseInt(Addon.GetChokedCommands());
	},
	GetLatency: function(Flow) {
		if (!Context.Addon.Loaded || !Addon.GetLatency) {
			return -1;
		}

		return parseFloat(Addon.GetLatency(Flow));	
	},
	SetViewAngles: function(ViewAngles) {
		if (!Context.Addon.Loaded || !Addon.SetViewAngles) {
			return Local.SetViewAngles(ViewAngles);
		}

		return Addon.SetViewAngles(ViewAngles);
	},
	GetMisses: function(EntityIndex) {
		if (!Context.Addon.Loaded || !Addon.GetMisses) {
			return;
		}

		return Addon.GetMisses(EntityIndex);
	},
};

const CurrentTab =
ui.AddDropdown('cynosa modulations', ['General Information', 'Ragebot Assistance', 'Anti-Aim Customization', 'Visual Additions', 'Miscellaneous', 'Configuration']);

ui.AddLabel('> Welcome, {0}!'.format(Context.FixedUsername), [CurrentTab], [0]);
ui.AddLabel('> Current version: {0} [{1}]'.format(Context.Version, Context.Build.toLowerCase()), [CurrentTab], [0]);
ui.AddLabel('dsc.gg/cynosatech', [CurrentTab], [0]);
ui.AddLabel('dsc.gg/nexushvh', [CurrentTab], [0]);

const RagebotDormantAimbot =
ui.AddHotkey('Dormant aimbot', [CurrentTab], [1]);
const RagebotMinimumDamage =
ui.AddCheckbox('Minimum damage on key', [CurrentTab], [1]);
ui.AddHotkey('Minimum damage', [CurrentTab, RagebotMinimumDamage], [1, true]);
ui.AddSliderInt('General DMG', 0, 130, 0, [CurrentTab, RagebotMinimumDamage], [1, true]);
ui.AddSliderInt('Auto DMG', 0, 130, 0, [CurrentTab, RagebotMinimumDamage], [1, true]);
ui.AddSliderInt('AWP DMG', 0, 130, 0, [CurrentTab, RagebotMinimumDamage], [1, true]);
ui.AddSliderInt('SSG08 DMG', 0, 130, 0, [CurrentTab, RagebotMinimumDamage], [1, true]);
ui.AddSliderInt('Revolver DMG', 0, 130, 0, [CurrentTab, RagebotMinimumDamage], [1, true]);
ui.AddSliderInt('Deagle DMG', 0, 130, 0, [CurrentTab, RagebotMinimumDamage], [1, true]);
ui.AddSliderInt('Pistol DMG', 0, 130, 0, [CurrentTab, RagebotMinimumDamage], [1, true]);

const RagebotHitchanceOverride = 
ui.AddCheckbox('Hitchance Override on key', [CurrentTab], [1]);
ui.AddHotkey('Hitchance Override', [CurrentTab, RagebotHitchanceOverride], [1, true]);
ui.AddSliderInt('General Hitchance', 0, 100, 0, [CurrentTab, RagebotHitchanceOverride], [1, true]);
ui.AddSliderInt('Auto Hitchance', 0, 100, 0, [CurrentTab, RagebotHitchanceOverride], [1, true]);
ui.AddSliderInt('AWP Hitchance', 0, 100, 0, [CurrentTab, RagebotHitchanceOverride], [1, true]);
ui.AddSliderInt('SSG08 Hitchance', 0, 100, 0, [CurrentTab, RagebotHitchanceOverride], [1, true]);
ui.AddSliderInt('Revolver Hitchance', 0, 100, 0, [CurrentTab, RagebotHitchanceOverride], [1, true]);
ui.AddSliderInt('Deagle Hitchance', 0, 100, 0, [CurrentTab, RagebotHitchanceOverride], [1, true]);
ui.AddSliderInt('Pistol Hitchance', 0, 100, 0, [CurrentTab, RagebotHitchanceOverride], [1, true]);
const RagebotJumpscout =
ui.AddCheckbox('Air hitchance', [CurrentTab], [1]);
ui.AddSliderInt('Air Scout & R8 hitchance', 0, 100, 0, [CurrentTab, RagebotJumpscout], [1, true]);
const RagebotNoscopeHitchance = 
ui.AddCheckbox('Noscope Hitchance', [CurrentTab], [1]);
const RagebotNoscopeHitchanceWeapons =
ui.AddMultiDropdown('Weapons:', ['Auto', 'AWP', 'SSG08'], [CurrentTab, RagebotNoscopeHitchance], [1, true]);
ui.AddSliderInt('Auto Noscope Hitchance', 0, 100, 0, [CurrentTab, RagebotNoscopeHitchance], [1, true], [], [], [RagebotNoscopeHitchanceWeapons], [0]);
ui.AddSliderInt('AWP Noscope Hitchance', 0, 100, 0, [CurrentTab, RagebotNoscopeHitchance], [1, true], [], [], [RagebotNoscopeHitchanceWeapons], [1]);
ui.AddSliderInt('SSG08 Noscope Hitchance', 0, 100, 0, [CurrentTab, RagebotNoscopeHitchance], [1, true], [], [], [RagebotNoscopeHitchanceWeapons], [2]);
const RagebotDTWithHSFix =
ui.AddCheckbox('DT with HS fix', [CurrentTab], [1]);
const RagebotDisableDTOnZeus =
ui.AddCheckbox('Disable DT on Zeus', [CurrentTab], [1]);
const RagebotTwoShot =
ui.AddCheckbox('Two shot', [CurrentTab], [1]);
const RagebotAdaptiveRecharge =
ui.AddCheckbox('Adaptive recharge', [CurrentTab], [1]);
const RagebotRevolverHelper =
ui.AddCheckbox('Revolver Helper', [CurrentTab], [1]);
const RagebotAdaptiveAutoscope =
ui.AddCheckbox('Dynamic Autoscope', [CurrentTab], [1]);
const RagebotForceSafeInLethal =
ui.AddCheckbox('Force Safepoint in lethal', [CurrentTab], [1]);
const RagebotAntiPredict =
ui.AddCheckbox('Anti Predict [BETA]', [CurrentTab], [1]);

const AntiAimTab =
ui.AddDropdown('Anti-Aim modulations', ['Other', 'Anti-Aim Settings'], [CurrentTab], [2]);
const AntiAimBuilder =
ui.AddCheckbox('Builder', [CurrentTab, AntiAimTab], [2, 1]);
const AntiAimFreestandingOnKey =
ui.AddHotkey('Freestanding', [CurrentTab, AntiAimTab], [2, 0]);
const AntiAimLegfucker = 
ui.AddCheckbox('Legbreaker', [CurrentTab, AntiAimTab], [2, 0]);
const AntiAimAdaptiveFakelag = 
ui.AddCheckbox('Adaptive Fake-Lag', [CurrentTab, AntiAimTab], [2, 0]);
const AntiAimTweaks = 
ui.AddMultiDropdown('Tweaks', ['Silent onshot', 'Random AA on warmup', 'Anti-backstab'], [CurrentTab, AntiAimTab, AntiAimBuilder], [2, 0, true]);
const AntiAimSafeHead =
ui.AddMultiDropdown('Safe head', ['Knife', 'Taser'], [CurrentTab, AntiAimTab, AntiAimBuilder], [2, 0, true]);
const AntiAimCustomManuals =
ui.AddCheckbox('Better Manuals', [CurrentTab, AntiAimTab, AntiAimBuilder], [2, 0, true, true]);
const AntiAimStaticManuals =
ui.AddCheckbox('Static Manual', [CurrentTab, AntiAimTab, AntiAimCustomManuals, AntiAimBuilder], [2, 0, true, true]);
const AntiAimLeftManual =
ui.AddHotkey('Left Manual', [CurrentTab, AntiAimTab, AntiAimCustomManuals, AntiAimBuilder], [2, 0, true, true]);
const AntiAimRightManual =
ui.AddHotkey('Right Manual', [CurrentTab, AntiAimTab, AntiAimCustomManuals, AntiAimBuilder], [2, 0, true, true]);
const AntiAimBackwardManual =
ui.AddHotkey('Backward Manual', [CurrentTab, AntiAimTab, AntiAimCustomManuals, AntiAimBuilder], [2, 0, true, true]);
const AntiAimForwardManual =
ui.AddHotkey('Forward Manual', [CurrentTab, AntiAimTab, AntiAimCustomManuals, AntiAimBuilder], [2, 0, true, true]);

const AntiAimBuilderTab =
ui.AddDropdown('Condition', Context.AntiAim.States, [CurrentTab, AntiAimTab, AntiAimBuilder], [2, 1, true]);

(function() {
	const State = '[' + Context.AntiAim.States[0] + '] ';
	Refs.Script.AntiAim.AtTargets[0] = ui.AddDropdown(State + 'Yaw base', ['Local view', 'At targets'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, 0]);
	Refs.Script.AntiAim.Pitch[0] = ui.AddDropdown(State + 'Pitch', ['None', 'Down', 'Emotion', 'Zero', 'Up', 'Fake up', 'Fake down', 'Random'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, 0]);
	Refs.Script.AntiAim.YawType[0] = ui.AddDropdown(State + 'Yaw Type', ['Default', 'Left/Right'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, 0]);
	Refs.Script.AntiAim.Yaw[0] = ui.AddSliderInt(State + 'Yaw', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, Refs.Script.AntiAim.YawType[0]], [2, 1, true, 0, 0]);
	Refs.Script.AntiAim.YawLeft[0] = ui.AddSliderInt(State + 'Yaw left', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, Refs.Script.AntiAim.YawType[0]], [2, 1, true, 0, 1]);
	Refs.Script.AntiAim.YawRight[0] = ui.AddSliderInt(State + 'Yaw right', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, Refs.Script.AntiAim.YawType[0]], [2, 1, true, 0, 1]);
	Refs.Script.AntiAim.YawJitter[0] = ui.AddSliderInt(State + 'Yaw jitter', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, 0]);
	Refs.Script.AntiAim.JitterEnable[0] = ui.AddCheckbox(State + 'Yaw Modifier Enable', [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, 0]);
	Refs.Script.AntiAim.YawModifier[0] = ui.AddDropdown(State + 'Yaw Modifier', ['Offset(Only with jitter)', 'Center(Only with jitter)', 'Random'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, Refs.Script.AntiAim.JitterEnable[0]], [2, 1, true, 0, true]);
	Refs.Script.AntiAim.YawRange[0] = ui.AddSliderInt(State + 'Yaw Modifier Range', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, Refs.Script.AntiAim.JitterEnable[0]], [2, 1, true, 0, true]);
	Refs.Script.AntiAim.YawRandomMin[0] = ui.AddSliderInt(State + 'Yaw Random Min', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, Refs.Script.AntiAim.JitterEnable[0]], [2, 1, true, 0, true], [Refs.Script.AntiAim.YawModifier[0]], [1]);
	Refs.Script.AntiAim.YawRandomMax[0] = ui.AddSliderInt(State + 'Yaw Random Max', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, Refs.Script.AntiAim.JitterEnable[0]], [2, 1, true, 0, true], [Refs.Script.AntiAim.YawModifier[0]], [1]);
	Refs.Script.AntiAim.YawSpin[0] = ui.AddCheckbox(State + 'Yaw Spin Enable', [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, i, true]);
	Refs.Script.AntiAim.YawSpeedSpin[0] = ui.AddSliderInt(State + 'Yaw Speed Spin', 1, 10, 1, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, Refs.Script.AntiAim.YawSpin[0]], [2, 1, true, i, true, true]);
	Refs.Script.AntiAim.YawOffsetSpin[0] = ui.AddSliderInt(State + 'Yaw Offset Spin', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, Refs.Script.AntiAim.YawSpin[0]], [2, 1, true, i, true, true]);
	Refs.Script.AntiAim.DesyncType[0] = ui.AddDropdown(State + 'Body yaw', ['Off', 'Normal', 'Opposite', 'Sway', 'Custom', 'Custom sway', 'Random'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, 0]);
	Refs.Script.AntiAim.DesyncLimitLeft[0] = ui.AddSliderInt(State + 'Custom desync limit Left', -60, 60, -60, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, 0], [Refs.Script.AntiAim.DesyncType[0]], [1], [Refs.Script.AntiAim.DesyncType[0]], [2]);
	Refs.Script.AntiAim.DesyncLimitRight[0] = ui.AddSliderInt(State + 'Custom desync limit Right', -60, 60, 60, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, 0], [Refs.Script.AntiAim.DesyncType[0]], [1], [Refs.Script.AntiAim.DesyncType[0]], [2]);
	Refs.Script.AntiAim.DesyncRandomMin[0] = ui.AddSliderInt(State + 'Custom desync random min', 0, 60, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, 0], [Refs.Script.AntiAim.DesyncType[0]], [6], [Refs.Script.AntiAim.DesyncType[0]], [2]);
	Refs.Script.AntiAim.DesyncRandomMax[0] = ui.AddSliderInt(State + 'Custom desync random max', 0, 60, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, 0], [Refs.Script.AntiAim.DesyncType[0]], [6], [Refs.Script.AntiAim.DesyncType[0]], [2]);
	Refs.Script.AntiAim.Options[0] = ui.AddMultiDropdown(State + 'Options', ["Avoid Overlap", "Hide Real Angle", 'Desync on shot', 'Jitter', 'Randomize Jitter', 'Switch on shot'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, true, 0], [Refs.Script.AntiAim.DesyncType[0]], [1]);
	Refs.Script.AntiAim.InverterFlipTime[0] = ui.AddSliderInt(State + 'Jitter flip Time', 1, 100, 1, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, 0], [Refs.Script.AntiAim.DesyncType[0]], [1], [Refs.Script.AntiAim.Options[0]], [3]);
	Refs.Script.AntiAim.AntiBrute[0] = ui.AddCheckbox(State + 'Anti-Bruteforce Enable', [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab], [2, 1, true, 0], [Refs.Script.AntiAim.DesyncType[0]], [1]);
	Refs.Script.AntiAim.AntiBruteType[0] = ui.AddDropdown(State + 'Anti-Bruteforce Type', ['On hurt', 'On Miss [BETA]'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, Refs.Script.AntiAim.AntiBrute[0]], [2, 1, true, 0, true], [Refs.Script.AntiAim.DesyncType[0]], [1]);
})();

for (var i = 1; i < Context.AntiAim.States.length; i++) {
	const State = '[' + Context.AntiAim.States[i] + '] ';
	const StateEnable = ui.AddCheckbox(State + 'Enable', [CurrentTab, AntiAimTab, AntiAimBuilderTab, AntiAimBuilder], [2, 1, i, true]);
	Refs.Script.AntiAim.AtTargets[i] = ui.AddDropdown(State + 'Yaw base', ['Local view', 'At targets'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true]);
	Refs.Script.AntiAim.Pitch[i] = ui.AddDropdown(State + 'Pitch', ['None', 'Down', 'Emotion', 'Zero', 'Up', 'Fake up', 'Fake down', 'Random'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true]);
	Refs.Script.AntiAim.YawType[i] = ui.AddDropdown(State + 'Yaw Type', ['Default', 'Left/Right'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true]);
	Refs.Script.AntiAim.Yaw[i] = ui.AddSliderInt(State + 'Yaw', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable, Refs.Script.AntiAim.YawType[i]], [2, 1, true, i, true, 0]);
	Refs.Script.AntiAim.YawLeft[i] = ui.AddSliderInt(State + 'Yaw left', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable, Refs.Script.AntiAim.YawType[i]], [2, 1, true, i, true, 1]);
	Refs.Script.AntiAim.YawRight[i] = ui.AddSliderInt(State + 'Yaw right', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable, Refs.Script.AntiAim.YawType[i]], [2, 1, true, i, true, 1]);
	Refs.Script.AntiAim.YawJitter[i] = ui.AddSliderInt(State + 'Yaw jitter', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true]);
	Refs.Script.AntiAim.JitterEnable[i] = ui.AddCheckbox(State + 'Yaw Modifier Enable', [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true]);
	Refs.Script.AntiAim.YawModifier[i] = ui.AddDropdown(State + 'Yaw Modifier', ['Offset(Only with jitter)', 'Center(Only with jitter)', 'Random'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable, Refs.Script.AntiAim.JitterEnable[i]], [2, 1, true, i, true, true]);
	Refs.Script.AntiAim.YawRange[i] = ui.AddSliderInt(State + 'Yaw Modifier Range', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable, Refs.Script.AntiAim.JitterEnable[i]], [2, 1, true, i, true, true]);
	Refs.Script.AntiAim.YawRandomMin[i] = ui.AddSliderInt(State + 'Yaw Random Min', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable, Refs.Script.AntiAim.JitterEnable[i]], [2, 1, true, i, true, true], [Refs.Script.AntiAim.YawModifier[i]], [2]);
	Refs.Script.AntiAim.YawRandomMax[i] = ui.AddSliderInt(State + 'Yaw Random Max', -180, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable, Refs.Script.AntiAim.JitterEnable[i]], [2, 1, true, i, true, true], [Refs.Script.AntiAim.YawModifier[i]], [2]);
	Refs.Script.AntiAim.YawSpin[i] = ui.AddCheckbox(State + 'Yaw Spin Enable', [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true]);
	Refs.Script.AntiAim.YawSpeedSpin[i] = ui.AddSliderInt(State + 'Yaw Speed Spin', 1, 10, 1, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable, Refs.Script.AntiAim.YawSpin[i]], [2, 1, true, i, true, true]);
	Refs.Script.AntiAim.YawOffsetSpin[i] = ui.AddSliderInt(State + 'Yaw Offset Spin', 0, 180, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable, Refs.Script.AntiAim.YawSpin[i]], [2, 1, true, i, true, true]);
	Refs.Script.AntiAim.DesyncType[i] = ui.AddDropdown(State + 'Body yaw', ['Off', 'Normal', 'Opposite', 'Sway', 'Custom', 'Custom sway', 'Random'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true]);
	Refs.Script.AntiAim.DesyncLimitLeft[i] = ui.AddSliderInt(State + 'Custom desync limit Left', -60, 60, -60, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true], [Refs.Script.AntiAim.DesyncType[i]], [1], [Refs.Script.AntiAim.DesyncType[i]], [2]);
	Refs.Script.AntiAim.DesyncLimitRight[i] = ui.AddSliderInt(State + 'Custom desync limit Right', -60, 60, 60, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true], [Refs.Script.AntiAim.DesyncType[i]], [1], [Refs.Script.AntiAim.DesyncType[i]], [2]);
	Refs.Script.AntiAim.DesyncRandomMin[i] = ui.AddSliderInt(State + 'Custom desync random min', 0, 60, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true], [Refs.Script.AntiAim.DesyncType[i]], [6], [Refs.Script.AntiAim.DesyncType[i]], [2]);
	Refs.Script.AntiAim.DesyncRandomMax[i] = ui.AddSliderInt(State + 'Custom desync random max', 0, 60, 0, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true], [Refs.Script.AntiAim.DesyncType[i]], [6], [Refs.Script.AntiAim.DesyncType[i]], [2]);
	Refs.Script.AntiAim.Options[i] = ui.AddMultiDropdown(State + 'Options', ["Avoid Overlap", "Hide Real Angle", 'Desync on shot', 'Jitter', 'Randomize Jitter', 'Switch on shot'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true], [Refs.Script.AntiAim.DesyncType[i]], [1]);
	Refs.Script.AntiAim.InverterFlipTime[i] = ui.AddSliderInt(State + 'Jitter flip Time', 1, 100, 1, [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true], [Refs.Script.AntiAim.DesyncType[i]], [1], [Refs.Script.AntiAim.Options[i]], [3]);
	Refs.Script.AntiAim.AntiBrute[i] = ui.AddCheckbox(State + 'Anti-Bruteforce Enable', [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable], [2, 1, true, i, true], [Refs.Script.AntiAim.DesyncType[i]], [1]);
	Refs.Script.AntiAim.AntiBruteType[i] = ui.AddDropdown(State + 'Anti-Bruteforce Type', ['On hurt', 'On Miss [BETA]'], [CurrentTab, AntiAimTab, AntiAimBuilder, AntiAimBuilderTab, StateEnable, Refs.Script.AntiAim.AntiBrute[i]], [2, 1, true, i, true, true], [Refs.Script.AntiAim.DesyncType[i]], [1]);
}	

const VisualIndicators =
ui.AddDropdown('Indicators', ['Disabled', 'Cynosa', 'Cynosa Gradient', 'xo-yaw style'], [CurrentTab], [3]);
ui.AddColorPicker('Main color', [174, 182, 233, 255], [CurrentTab], [3]);
ui.AddColorPicker('Alternative color', [174, 182, 233, 255], [CurrentTab], [3]);

const VisualOptimize =
ui.AddCheckbox('Optimize font for 2k monitors', [CurrentTab], [3]);

const VisualSkeetIndicators =
ui.AddDropdown('Skeet indicators', ['Disabled', 'Default', 'Animated'], [CurrentTab], [3]);
const VisualSkeetLC =
ui.AddCheckbox('LC', [CurrentTab], [3], [VisualSkeetIndicators], [1]);
const VisualShotsCounter =
ui.AddCheckbox('Shots counter', [CurrentTab], [3], [VisualSkeetIndicators], [1]);
const Visual500Spectators =
ui.AddCheckbox('500$ Spectators', [CurrentTab], [3]);

const VisualKeepScopeTransparancy =
ui.AddCheckbox('Keep scope transparency', [CurrentTab], [3]);
const VisualScopeChamsType =
ui.AddDropdown('Visible type:', ['Material', 'Custom', 'Flat', 'Pulse', 'Wireframe', 'Glow', 'Glow 2-color'], [CurrentTab, VisualKeepScopeTransparancy], [3, true]);
const VisualScopeTransparancy =
ui.AddSliderInt('Scope transparency', 0, 100, 60, [CurrentTab, VisualKeepScopeTransparancy], [3, true]);
const VisualLocalTransparancy =
ui.AddSliderInt('Local transparency', 0, 100, 0, [CurrentTab, VisualKeepScopeTransparancy], [3, true]);

const VisualGrenadeTransparancy =
ui.AddCheckbox('Grenade transparency', [CurrentTab], [3]);
const VisualGrenadeChamsType =
ui.AddDropdown('Grenade Visible type:', ['Material', 'Custom', 'Flat', 'Pulse', 'Wireframe', 'Glow', 'Glow 2-color'], [CurrentTab, VisualGrenadeTransparancy], [3, true]);
const VisualOngrenadeTransparancy =
ui.AddSliderInt('On grenade transparency', 0, 100, 60, [CurrentTab, VisualGrenadeTransparancy], [3, true]);
const VisualGrenadeLocalTransparancy =
ui.AddSliderInt('Without grenade local transparency', 0, 100, 0, [CurrentTab, VisualGrenadeTransparancy], [3, true]);

const VisualBulletTracer =
ui.AddCheckbox('Bullet Tracer', [CurrentTab], [3]);
ui.AddColorPicker('Bullet Tracer color', [255, 255, 255, 255], [CurrentTab, VisualBulletTracer], [3, true]);

const VisualKibitMarker =
ui.AddCheckbox('Kibit world marker', [CurrentTab], [3]);
const VisualKibitMarkerColor =
ui.AddCheckbox('Kibit Custom Color', [CurrentTab, VisualKibitMarker], [3, true]);
ui.AddColorPicker('Main Kibit color', [40, 255, 255, 255], [CurrentTab, VisualKibitMarker, VisualKibitMarkerColor], [3, true, true]);
ui.AddColorPicker('Alternative Kibit color', [0, 255, 100, 255], [CurrentTab, VisualKibitMarker, VisualKibitMarkerColor], [3, true, true]);
const VisualCrosshairHitmarker =
ui.AddCheckbox('Crosshair hitmarker', [CurrentTab], [3]);
const VisualCrosshairHitmarkerColor =
ui.AddColorPicker('Crosshair hitmarker color', [255, 255, 255, 255], [CurrentTab, VisualCrosshairHitmarker], [3, true]);

const MiscAspectRatio =
ui.AddCheckbox('AspectRatio Enable', [CurrentTab], [3]);
const MiscAspectRatioRef =
ui.AddSliderFloat('AspectRatio Value', 0, 5, 0, [CurrentTab, MiscAspectRatio], [3, true]);
const MiscThirdperson =
ui.AddCheckbox('Thirdperson Enable', [CurrentTab], [3]);
const MiscThirdpersonRef =
ui.AddSliderInt('Thirdperson Value', 0, 300, 100, [CurrentTab, MiscThirdperson], [3, true]);

const VisualDmgIndicator = 
ui.AddCheckbox('DMG indicator', [CurrentTab], [3]);
const VisualDmgColor =
ui.AddColorPicker('DMG indicator color', [255, 255, 255, 255], [CurrentTab, VisualDmgIndicator], [3, true]);
const VisualDmgActiveColor =
ui.AddColorPicker('Min.DMG indicator color', [255, 255, 255, 255], [CurrentTab, VisualDmgIndicator], [3, true]);
const VisualDmgFont =
ui.AddDropdown('DMG Font', ['Verdana', 'Small fonts'], [CurrentTab, VisualDmgIndicator], [3, true]);

const VisualManualArrows =
ui.AddCheckbox('Manual Arrows', [CurrentTab, AntiAimCustomManuals], [3, true]);
const VisualManualArrowsStyle =
ui.AddDropdown('Manual Style', ['Default', 'Arrows'], [CurrentTab, AntiAimCustomManuals, VisualManualArrows], [3, true, true]);

const VisualWatermarkStyle =
ui.AddDropdown('Watermark Style', ['Default', 'Cynosa #1', 'Cynosa #2'], [CurrentTab, VisualIndicators], [3, 0]);

const RagebotPingSpike =
ui.AddHotkey('Ping spike', [CurrentTab], [4]);

const MiscLogs =
ui.AddCheckbox('Enable Logs', [CurrentTab], [4]);
const MiscCustomColorLogs =
ui.AddCheckbox('Custom Color for logs', [CurrentTab, MiscLogs], [4, true]);
const MiscColorMainLog =
ui.AddColorPicker('Main Log color', [159, 202, 43, 255], [CurrentTab, MiscLogs, MiscCustomColorLogs], [4, true, true]);
const MiscColorMissLog =
ui.AddColorPicker('Miss Log color', [255, 0, 50, 255], [CurrentTab, MiscLogs, MiscCustomColorLogs], [4, true, true]);
const MiscCrosshairLogs =
ui.AddCheckbox('Crosshair log', [CurrentTab, MiscLogs], [4, true]);
const MiscChoiceOfLogs =
ui.AddMultiDropdown('Choice of logs', ['BuyLog', 'Hitlog'], [CurrentTab, MiscLogs, MiscCrosshairLogs], [4, true, true]);

const MiscLogsEvent =
ui.AddCheckbox('Event log', [CurrentTab, MiscLogs], [4, true]);
const MiscLogsEventFont =
ui.AddDropdown('Event Font', ['Verdana', 'Verdana Bold'], [CurrentTab, MiscLogs, MiscLogsEvent], [4, true, true]);
const MiscBuyLog =
ui.AddCheckbox('Buy log', [CurrentTab, MiscLogs], [4, true]);
const MiscEnemyChatViewer =
ui.AddCheckbox('Enemy chat viewer', [CurrentTab, MiscLogs], [4, true]);

const MiscClantag =
ui.AddCheckbox('Clantag', [CurrentTab], [4]);

const MiscTrashtalk =
ui.AddCheckbox('Trashtalk', [CurrentTab], [4]);

const MiscAutostraferFix =
ui.AddCheckbox('Autostrafer Fix', [CurrentTab], [4]);
const MiscAutostraferModifier =
ui.AddSliderInt('Autostrafer modifier', 1, 100, 1, [CurrentTab, MiscAutostraferFix], [4, true]);

const MiscSmartBuybot =
ui.AddCheckbox('Smart BuyBot', [CurrentTab], [4]);

const MiscQuickSwitch =
ui.AddCheckbox('Quick Switch', [CurrentTab], [4]);

const MiscMusicKit =
ui.AddCheckbox('Custom Music kit', [CurrentTab], [4]);
const MiscMusicKitSet =
ui.AddSliderInt('Music kit', 1, 52, 1, [CurrentTab, MiscMusicKit], [4, true]);

const ConfigImport =
ui.AddCheckbox('Import', [CurrentTab], [5]);
const ConfigExport =
ui.AddCheckbox('Export', [CurrentTab], [5]);
const ZV =
ui.AddCheckbox('ZV', [CurrentTab], [5]);

ui.SetValue(ConfigImport, 0);
ui.SetValue(ConfigExport, 0);

function GetWeaponName() {
	if (Context.LocalPlayer.Weapon.ClassName == 'CDEagle' && Context.LocalPlayer.Weapon.Name != 'desert eagle') {
		return 'Revolver';
	}

	switch (Context.LocalPlayer.Weapon.Name) {
		case 'ssg 08':
			return 'SSG08';

		case 'scar 20':
		case 'g3sg1':
			return 'Auto';

		case 'awp':
			return 'AWP';

		case 'desert eagle':
			return 'Deagle';

		case 'r8 revolver':
			return 'Revolver';

		case 'p2000':
		case 'five seven':
		case 'p250':
		case 'usp s':
		case 'dual berettas':
		case 'cz75 auto':
		case 'tec 9':
		case 'glock 18':
			return 'Pistol';
	}

	return 'General';
}

function GetTabName() {
	if (Context.LocalPlayer.Weapon.ClassName == 'CDEagle' && Context.LocalPlayer.Weapon.Name != 'desert eagle') {
		return 'HEAVY PISTOL';
	}

	switch (Context.LocalPlayer.Weapon.Name) {
		case 'ssg 08':
			return 'SCOUT';

		case 'scar 20':
		case 'g3sg1':
			return 'AUTO';

		case 'awp':
			return 'AWP';

		case 'desert eagle':
		case 'r8 revolver':
			return 'HEAVY PISTOL';

		case 'p2000':
		case 'five seven':
		case 'p250':
		case 'usp s':
		case 'dual berettas':
		case 'cz75 auto':
		case 'tec 9':
		case 'glock 18':
			return 'PISTOL';
	}

	return 'GENERAL';
}

function DamageOverride() {
	if (!Context.Keybinds.MinimumDamage) {
		return;
	}

	const NewDamage = UI.GetValue('Script items', Context.Rage.CurrentWeapon + ' DMG');
	const Enemies = Entity.GetEnemies();

	Context.Rage.MinimumDamage = NewDamage;

	for (var i = 0; i < Enemies.length; i++) {
		const Enemy = Enemies[i];
		if (!Entity.IsValid(Enemy) || !Entity.IsAlive(Enemy) || Entity.IsDormant(Enemy)) {
			continue;
		}

		Ragebot.ForceTargetMinimumDamage(Enemy, NewDamage);
	}
}

function HitchanceOverride() {
	if (!Context.Keybinds.HitchanceOverride) {
		return;
	}

	const NewHitchance = UI.GetValue('Script items', Context.Rage.CurrentWeapon + ' Hitchance');
	const Enemies = Entity.GetEnemies();

	Context.Rage.MinimumHitchance = NewHitchance;

	for (var i = 0; i < Enemies.length; i++) {
		const Enemy = Enemies[i];
		if (!Entity.IsValid(Enemy) || !Entity.IsAlive(Enemy) || Entity.IsDormant(Enemy)) {
			continue;
		}

		Ragebot.ForceTargetHitchance(Enemy, NewHitchance);
	}
}

function NoscopeHitchance() {
	if (!ui.GetValue(RagebotNoscopeHitchance) || Context.LocalPlayer.Netvars.Scoped || Context.Keybinds.HitchanceOverride || !Context.LocalPlayer.OnGround && ui.GetValue(RagebotJumpscout) && Context.Rage.CurrentWeapon == 'SSG08') {
		return;
	}

	const NewHitchance = Context.Rage.MinimumHitchance;
	if (ui.GetDropdown(RagebotNoscopeHitchanceWeapons, 0) && Context.Rage.CurrentWeapon == 'Auto') {
		NewHitchance = UI.GetValue('Script items', 'Auto Noscope Hitchance');
	} else if (ui.GetDropdown(RagebotNoscopeHitchanceWeapons, 1) && Context.Rage.CurrentWeapon == 'AWP') {
		NewHitchance = UI.GetValue('Script items', 'AWP Noscope Hitchance');
	} else if (ui.GetDropdown(RagebotNoscopeHitchanceWeapons, 2) && Context.Rage.CurrentWeapon == 'SSG08') {
		NewHitchance = UI.GetValue('Script items', 'SSG08 Noscope Hitchance');
	}

	Context.Rage.MinimumHitchance = NewHitchance;
	const Enemies = Entity.GetEnemies();
	for (var i = 0; i < Enemies.length; i++) {
		const Enemy = Enemies[i];
		if (!Entity.IsValid(Enemy) || !Entity.IsAlive(Enemy) || Entity.IsDormant(Enemy)) {
			continue;
		}

		Ragebot.ForceTargetHitchance(Enemy, NewHitchance);
	}
}

function JumpScout() {
	if (!ui.GetValue(RagebotJumpscout) || Context.Keybinds.HitchanceOverride || Context.LocalPlayer.OnGround) {
		return;
	}
	
	if (Context.Rage.CurrentWeapon == 'SSG08' || Context.Rage.CurrentWeapon == 'Revolver') {
		const NewHitchance = UI.GetValue('Script items', 'Air Scout & R8 hitchance');
		const Enemies = Entity.GetEnemies();

		Context.Rage.MinimumHitchance = NewHitchance;

		for (var i = 0; i < Enemies.length; i++) {
			const Enemy = Enemies[i];
			if (!Entity.IsValid(Enemy) || !Entity.IsAlive(Enemy) || Entity.IsDormant(Enemy)) {
				continue;
			}

			Ragebot.ForceTargetHitchance(Enemy, NewHitchance);
		}
	}
}

function PingSpike() {
	if (!Context.LocalPlayer.Alive) {
		ui.SetValue(Refs.Misc.ExtendedBacktrack, 0);
		return;
	}

	ui.SetValue(Refs.Misc.ExtendedBacktrack, Context.Keybinds.PingSpike);
}

function RevolverHelper() {
	if (!ui.GetValue(RagebotRevolverHelper)) {
		return;
	}

	const Screen = {
		X: Render.WorldToScreen(Entity.GetHitboxPosition(Context.LocalPlayer.Index, 3))[0],
		Y: Render.WorldToScreen(Entity.GetHitboxPosition(Context.LocalPlayer.Index, 3))[1],
	}

	const Target = Entity.GetEnemies();
	const Color = [255, 255, 255, 255];
	const LocalHealth = Entity.GetProp(Context.LocalPlayer.Index, "CBasePlayer", "m_iHealth");
	const LocalNotKevlar = Entity.GetProp(Context.LocalPlayer.Index, "CCSPlayerResource", "m_iArmor") == 0;
	for (i = 0; i < Target.length; i++) {
		const Targets = Target[i];
		if (!Entity.IsAlive(Targets) || Entity.IsDormant(Targets) || !Entity.IsAlive(Targets)) {
			continue;
		}
		
		const EnemyRevolver = false;
		if (Entity.GetName(Entity.GetWeapon(Targets)) == 'r8 revolver' || Entity.GetClassName(Entity.GetWeapon(Targets)) == 'CDEagle' && Entity.GetName(Entity.GetWeapon(Targets)) != 'desert eagle') {
			EnemyRevolver = true;
		}
		
		const NotKevlar = Entity.GetProp(Targets, "CCSPlayerResource", "m_iArmor") == 0;
		const Health = Entity.GetProp(Targets, "CBasePlayer", "m_iHealth");
		const Hitbox = Entity.GetHitboxPosition(Targets, 3);
		const W2S = Render.WorldToScreen(Hitbox)
		if ((EnemyRevolver && Context.LocalPlayer.EyePosition.DistanceTo(Entity.GetRenderOrigin(Targets)) < 594 && LocalNotKevlar || EnemyRevolver && LocalHealth <= 60) || (Context.Rage.CurrentWeapon == 'Revolver' && Context.LocalPlayer.EyePosition.DistanceTo(Entity.GetRenderOrigin(Targets)) < 594 && NotKevlar || Context.Rage.CurrentWeapon == 'Revolver' && Health <= 60)) {
			if (EnemyRevolver && Context.LocalPlayer.EyePosition.DistanceTo(Entity.GetRenderOrigin(Targets)) < 594 && LocalNotKevlar || EnemyRevolver && LocalHealth <= 60) {
				Color = [255, 0, 0, 255];
			}

			Render.Line(Screen.X, Screen.Y, W2S[0], W2S[1], Color);
		}
	}
}

function AntiPredict() {
	if (!ui.GetValue(RagebotAntiPredict)) {
		return;
	}
	
	Context.Rage.AntiPredict = false;

	if (Context.Keybinds.Autopeek) {
		ui.SetValue(Refs.Misc.Slidewalk, 1);
		ui.SetValue(Refs.AntiAim.JitterMove, 0);
		Context.Rage.AntiPredict = true;
	} else {
		if (!ui.GetValue(AntiAimLegfucker)){
			ui.SetValue(Refs.Misc.Slidewalk, 0);
		}
	}
	
	if (Context.Rage.ExploitCharge != 1) {
		ui.SetValue(Refs.AntiAim.JitterMove, Math.Random(0, 1));
	} else {
		ui.SetValue(Refs.AntiAim.JitterMove, 0);
	}
}

function PredictTarget() {
	const LocalOrigin = Context.LocalPlayer.EyePosition;

	return Entity.GetEnemies().filter(function(Ent) {
		return Entity.IsAlive(Ent) && !Entity.IsDormant(Ent) && Entity.IsValid(Ent);
	}).sort(function(A, B) {
		const OriginA = Vector(Entity.GetRenderOrigin(A));
		const OriginB = Vector(Entity.GetRenderOrigin(B));
		const DistanceA = OriginA.DistanceTo(LocalOrigin);
		const DistanceB = OriginB.DistanceTo(LocalOrigin);
		
		if (DistanceA > DistanceB) {
			return 1;
		}

		if (DistanceB > DistanceA) {
			return -1;
		}
		
	}).sort(function(A, B) {
		const HealthA = Entity.GetProp(A, 'DT_BasePlayer', 'm_iHealth');
		const HealthB = Entity.GetProp(B, 'DT_BasePlayer', 'm_iHealth');
		
		if (HealthA > HealthB) {
			return 1;
		}

		if (HealthB > HealthA) {
			return -1;
		}
		
	})[0];
}

function ClosestTarget() {
	const LocalOrigin = Context.LocalPlayer.EyePosition;

	return Entity.GetEnemies().filter(function(Ent) {
		return Entity.IsAlive(Ent) && Entity.IsValid(Ent);
	}).sort(function(A, B) {
		const OriginA = Vector(Entity.GetRenderOrigin(A));
		const OriginB = Vector(Entity.GetRenderOrigin(B));
		const DistanceA = OriginA.DistanceTo(LocalOrigin);
		const DistanceB = OriginB.DistanceTo(LocalOrigin);
		
		if (DistanceA > DistanceB) {
			return 1;
		}

		if (DistanceB > DistanceA) {
			return -1;
		}
		
		return 0;
	})[0];
}

function ForceSafepointInLethal() {
	if (!ui.GetValue(RagebotForceSafeInLethal) || Context.Keybinds.ForceSafe) {
		return;
	}

	const LethalDmg = {
		Auto: 60,
		SSG08: 80,
		AWP: 90,
		General: 20,
		Pistol: 10,
		Revolver: 30,
		Deagle: 30,
	}

	const Enemies = Entity.GetEnemies();
	for (var i = 0; i < Enemies.length; i++) {
		const Enemy = Enemies[i];
		if (!Entity.IsValid(Enemy) || !Entity.IsAlive(Enemy) || Entity.IsDormant(Enemy)) {
			continue;
		}

		const Heatlh = Entity.GetProp(Enemy, 'DT_BasePlayer', 'm_iHealth');
		if (Heatlh <= LethalDmg[Context.Rage.CurrentWeapon]) {
			Ragebot.ForceTargetSafety(Enemy);
		}
	}
}

function AdaptiveAutoscope() {
	if (!ui.GetValue(RagebotAdaptiveAutoscope) || !Context.Rage.ClosestTarget) {
		return;
    }

	const NoscopeDistance = {
		Auto: 600,
		SSG08: 300,
		AWP: 200,
		General: 1000,
	}

    const ShouldScope = Context.LocalPlayer.EyePosition.DistanceTo(Entity.GetRenderOrigin(Context.Rage.ClosestTarget)) >= NoscopeDistance[Context.Rage.CurrentWeapon];
    ui.SetValue(Refs.Rage.Autoscope, ShouldScope);
}


function CanShiftShot(Ticks) {
	const Curtime = Context.Globals.TickInterval * (Context.LocalPlayer.Netvars.Tickbase - Ticks);
	return Curtime >= Context.LocalPlayer.Netvars.NextPrimaryAttack && Curtime > Context.LocalPlayer.Netvars.NextAttack;
}

function FastRecharge() {
	if (!ui.GetValue(RagebotAdaptiveRecharge) || !Context.Keybinds.Doubletap && !Context.Keybinds.Hideshots || Context.Rage.CurrentWeapon == 'Revolver' || Context.Rage.CurrentWeapon == 'SSG08' || Context.Rage.CurrentWeapon == 'AWP') {
		Exploit.EnableRecharge();
		return;
	}

	Exploit[(Context.Rage.ExploitCharge != 1 ? 'Enable' : 'Disable') + 'Recharge']();
	
	if (Context.Rage.ExploitCharge != 1 && CanShiftShot(20)) {
		Exploit.DisableRecharge();
		Exploit.Recharge();
	}
}

function TwoShot() {
	if (!ui.GetValue(RagebotTwoShot) || Context.Keybinds.MinimumDamage || !Context.Keybinds.Doubletap) {	
		return;
	}
	
	const Damage = Context.Rage.MinimumDamage;
	const Enemies = Entity.GetEnemies();
	for (var i = 0; i < Enemies.length; i++) {
		const Enemy = Enemies[i];
		if (!Entity.IsAlive(Enemy) || Entity.IsDormant(Enemy) || !Entity.IsValid(Enemy)) {
			Context.Rage.LastShot.Exploit = 0;
			continue;
		}

		const Health = Entity.GetProp(Enemy, 'DT_BasePlayer', 'm_iHealth');
		if (Context.Rage.CurrentWeapon == 'Auto') {
			if (Context.Rage.LastShot.Exploit == 1 && Health <= 60) {
				Damage = Health;
				Ragebot.ForceTarget(Enemy);
				Ragebot.ForceTargetMinimumDamage(Enemy, Damage);
			}
		}
	
		if (Context.Rage.CurrentWeapon == 'Deagle') {
			if (Context.Rage.LastShot.Exploit == 1 && Health <= 50) {
				Damage = Health;
				Ragebot.ForceTarget(Enemy);
				Ragebot.ForceTargetMinimumDamage(Enemy, Damage);
			}
		}
	}
}

function FreestandingOnKey() {
	ui.SetValue(Refs.AntiAim.AutoDirection, Context.Keybinds.Freestanding);
}

function RadiansToDegrees(Radians) {
    return Radians * 180 / Math.PI;
}

function GetAngleBetweenVectors(Origin, Destination) {
	const Delta = Destination.SubAlt(Origin);
    return [RadiansToDegrees(Math.atan2(Delta.Z, Math.sqrt(Delta.X * Delta.X + Delta.Y * Delta.Y))), RadiansToDegrees(Math.atan2(Delta.Y, Delta.X)), 0];
}

function DormantAimbot() {
	if (!Context.Rage.RestoredAttack) {
		Cheat.ExecuteCommand('-attack');
		Context.Rage.RestoredAttack = true;
	}
	
	if (!ui.GetHotkey(RagebotDormantAimbot)) {
		return;
	}

	if (Local.GetInaccuracy() > 0.05 || !Context.LocalPlayer.CanFire) {
		return;
	}

	const Enemies = Entity.GetEnemies();
	const ShootPosition = Context.LocalPlayer.EyePosition;

	for (var i = 0; i < Enemies.length; i++) {
		const Enemy = Enemies[i];
		if (!Enemy || !Entity.IsAlive(Enemy) || !Entity.IsDormant(Enemy)) {
			continue;
		}
		
		const EnemyBodyPosition = Vector(Entity.GetRenderOrigin(Enemy));
		EnemyBodyPosition.Z += Entity.GetProp(Enemy, 'DT_BasePlayer', 'm_vecViewOffset[0]')[2] / 1.15;
		const TraceResult = Trace.Bullet(Context.LocalPlayer.Index, Enemy, ShootPosition.ToArray(), EnemyBodyPosition.ToArray());
		if (TraceResult[1] <= 0) {
			continue;
		}
 
		AddonFunctions.SetViewAngles(GetAngleBetweenVectors(ShootPosition, EnemyBodyPosition));
		
		Cheat.ExecuteCommand('+attack');

		Context.Rage.RestoredAttack = false;

		break;
	}
}

function SilentOnShot() {
	if (!ui.GetMultiDropdown(AntiAimTweaks, 0) || !ui.GetValue(AntiAimBuilder)) {
		if (!Context.AntiAim.RestoredSilent) {
			ui.SetValue(Refs.Fakelag.Enabled, 1);
			Context.AntiAim.SilentTick = Context.Globals.Tickcount;
			Context.AntiAim.Silent = false;
			Context.AntiAim.RestoredSilent = true;
		}

		return;
	}

	const InSilent = Context.Globals.Tickcount < Context.AntiAim.SilentTick && Context.AntiAim.Silent != false;
	if (InSilent && Context.AntiAim.RestoredSilent) {
		Context.FakeLag.Backup = Context.FakeLag.Enabled;
		Context.AntiAim.RestoredSilent = false;
		Context.AntiAim.Silent = true;
	} else if (InSilent) {
		ui.SetValue(Refs.Fakelag.Enabled, 0);
		Context.AntiAim.RestoredSilent = false;
		Context.AntiAim.Silent = true;
	} else if (!InSilent && !Context.AntiAim.RestoredSilent) {
		ui.SetValue(Refs.Fakelag.Enabled, Context.FakeLag.Backup);
		Context.AntiAim.RestoredSilent = true;
		Context.AntiAim.Silent = false;
	}
}

function GetAntiAimState() {
	if (!Context.LocalPlayer.Alive) {
		return 0; // General
	}
	
	if (Context.Keybinds.LegitAA) {
		return 11; // Legit AA
	}
	
	if (Context.Keybinds.Freestanding && StateOrGeneral(10)) {
		return 10; // Freestand
	}
	
	if (Context.Rage.ExploitCharge <= 0.5 && StateOrGeneral(9) && ui.GetValue(Refs.Fakelag.Enabled) && ui.GetValue(Refs.Fakelag.Limit) >= 4 && ui.GetValue(Refs.Fakelag.TriggerLimit) >= 4 && !Context.Keybinds.Slowwalk && !(ui.GetValue(AntiAimAdaptiveFakelag) && (Context.AntiAim.State == 1 || Context.AntiAim.State == 4 || Context.AntiAim.State == 5 || Context.AntiAim.State == 3) || Context.AntiAim.State == 11 && Context.LocalPlayer.Velocity < 5)) {
		return 9; // Fakelag
	}

	if (!Context.LocalPlayer.OnGround) {
		if (Context.LocalPlayer.Netvars.DuckAmount) {
			return 8; // Air Crouch 
		}
		
		return 7; // Air
	}
	
	if (Context.LocalPlayer.Velocity > 5) {
		if (Context.LocalPlayer.Netvars.DuckAmount || Context.Keybinds.Fakeduck) {
			return 6; // Crouching+
		}
			
		if (Context.Keybinds.Slowwalk) {
			return 3; // Slowwalking
		}
		return 2; // Running 
	}

	if (Context.LocalPlayer.Netvars.DuckAmount && Context.LocalPlayer.Team == 2|| Context.Keybinds.Fakeduck && Context.LocalPlayer.Team == 2) {
		return 4; // Crouching T
	}

	if (Context.LocalPlayer.Netvars.DuckAmount && Context.LocalPlayer.Team == 3 || Context.Keybinds.Fakeduck && Context.LocalPlayer.Team == 3) {
		return 5; // Crouching CT
	}

	return 1; // Standing
}

function StateOrGeneral(Index) {
	return UI.GetValue('[' + Context.AntiAim.States[Index] + '] Enable') ? Index : 0;
}

function UpdateBodyState(DesyncType, DesyncLimit, RandomMin, RandomMax) {
	if (DesyncType < 4) {
		AntiAim.SetOverride(0);
		Context.AntiAim.RestoredOverride = true;
		return ui.SetValue(Refs.AntiAim.LbyMode, DesyncType - 1);
	}
	
	const Inverter = Context.Keybinds.Inverter ? 1 : -1;
	
	if (DesyncType == 4) {
		const Offset = DesyncLimit * Inverter;
	
		AntiAim.SetOverride(1);
		AntiAim.SetRealOffset(Offset);
		AntiAim.SetLBYOffset(-Offset);
	}

	if (DesyncType == 5) {
		Context.AntiAim.SwayState++;

		const States = [60, 45, 30, 15, 5];
		const Multiplier = DesyncLimit / 60;
	
		const Offset = States[Math.floor(Context.AntiAim.SwayState / States.length) % (States.length - 1)] * Multiplier * Inverter;
		
		AntiAim.SetOverride(1);
		AntiAim.SetRealOffset(Offset);
		AntiAim.SetLBYOffset(0);
	}

	if (DesyncType == 6) {
		const Offset = DesyncLimit * Inverter;

		AntiAim.SetOverride(1);
		AntiAim.SetRealOffset(Math.Random(RandomMin + Offset, Offset - RandomMax));
		AntiAim.SetLBYOffset(Math.Random(RandomMin - Offset, -Offset + RandomMax));
	}
}

function GetYaw(YawLeft, YawRight) {	
	return Context.Keybinds.Inverter ? YawLeft : YawRight;
}

function ShouldUseLegitAA() {
	if (!Context.LocalPlayer.Alive){	
		return false;
	} 
	
	if (Context.LocalPlayer.Weapon.ClassName == 'CC4') {
		return false;
	}

	const HostagesAndBomb = Entity.GetEntitiesByClassID(97).concat(Entity.GetEntitiesByClassID(128));
	for (var i = 0; i < HostagesAndBomb.length; i++) {
		const HostAndBombOrigin = Entity.GetRenderOrigin(HostagesAndBomb[i]);
		if (Context.LocalPlayer.EyePosition.DistanceTo2D(HostAndBombOrigin) > 62) {
			continue;
		}
		
		return false;
	}

	return true;
}

function ShouldUseAntiBackstab() {
	const Enemies = Entity.GetEnemies();
	for (var i = 0; i < Enemies.length; i++) {
		const Enemy = Enemies[i];
		if (!Entity.IsAlive(Enemy) || Entity.IsDormant(Enemy) || !Entity.IsValid(Enemy) || Entity.GetClassName(Entity.GetWeapon(Enemy)) != 'CKnife') {
			continue;
		}

		if (Trace.Line(Context.LocalPlayer.Index, Context.LocalPlayer.EyePosition.ToArray(), Entity.GetHitboxPosition(Enemy, 2))[0] != Enemy) {
			continue;
		}

		if (Context.LocalPlayer.EyePosition.DistanceTo2D(Entity.GetRenderOrigin(Enemy)) > 300) {
			continue;
		}
		
		return true;
	}

	return false;
}

function IsManualHotkeyActive(Ref) {
	const Value = ui.GetHotkey(Ref);
    const PrevValue = Context.AntiAim.ManualData[Ref];
	
	// storing original value to cache - сохранение исходного значения в кэш
	if (PrevValue == null) { 
		Context.AntiAim.ManualData[Ref] = Value;
		return false;
	}
	
    if (PrevValue == Value) {
		return false;
	}
	
	Context.AntiAim.ManualData[Ref] = Value;
    return true;
}

function UpdateManualHotkeys() {
	if (!ui.GetValue(AntiAimCustomManuals) || !ui.GetValue(AntiAimBuilder)) {
		Context.AntiAim.ManualYaw = 0;
		return;
	}
	
    if (IsManualHotkeyActive(Refs.Script.AntiAim.LeftManual)) {
		Context.AntiAim.ManualYaw = (Context.AntiAim.ManualYaw != Context.AntiAim.ManualLeft) ? Context.AntiAim.ManualLeft : 0;
    }
	
    if (IsManualHotkeyActive(Refs.Script.AntiAim.RightManual)) {
		Context.AntiAim.ManualYaw = (Context.AntiAim.ManualYaw != Context.AntiAim.ManualRight) ? Context.AntiAim.ManualRight : 0;
    }

    if (IsManualHotkeyActive(Refs.Script.AntiAim.BackwardManual)) {
		Context.AntiAim.ManualYaw = (Context.AntiAim.ManualYaw != Context.AntiAim.ManualBackward) ? Context.AntiAim.ManualBackward : 0;
    }
    if (IsManualHotkeyActive(Refs.Script.AntiAim.ForwardManual)) {
		Context.AntiAim.ManualYaw = (Context.AntiAim.ManualYaw != Context.AntiAim.ManualForward) ? Context.AntiAim.ManualForward : 0;
    }
}

const ManualDirections = {
	[Context.AntiAim.ManualLeft]: -90,
	[Context.AntiAim.ManualRight]: 90,
	[Context.AntiAim.ManualBackward]: 0,
	[Context.AntiAim.ManualForward]: 180,
}

function DesyncJitter() {
	const State = StateOrGeneral(Context.AntiAim.State);
	const Jitter = ui.GetMultiDropdown(Refs.Script.AntiAim.Options[State], 3);
	const RandomizeJitter = ui.GetMultiDropdown(Refs.Script.AntiAim.Options[State], 4);
	const InverterFlipTime = ui.GetValue(Refs.Script.AntiAim.InverterFlipTime[State]);
	if (Jitter && Math.abs(Context.Globals.Tickcount - Context.AntiAim.LastInvertTick) > Context.LocalPlayer.ChokedCommands + InverterFlipTime) {
		if (Context.AntiAim.AntiBrute || Context.AntiAim.SafeHead) {
			return;
		}

		if (ui.GetValue(AntiAimStaticManuals) && Context.AntiAim.ManualYaw > 0 && !Context.Keybinds.LegitAA) {
			return;
		}

        if (RandomizeJitter && Math.random() > 0.5) {
			ui.ToggleHotkey(Refs.AntiAim.Inverter);
			Context.Keybinds.Inverter = !Context.Keybinds.Inverter;
        }
		
		ui.ToggleHotkey(Refs.AntiAim.Inverter);
		Context.Keybinds.Inverter = !Context.Keybinds.Inverter;
        Context.AntiAim.LastInvertTick = Context.Globals.Tickcount;
    }
}

function AABuilder() {
	if (!Context.AntiAim.RestoredOverride) {
		AntiAim.SetOverride(0);
		Context.AntiAim.RestoredOverride = true;
	}

	const State = StateOrGeneral(Context.AntiAim.State);
	const AtTargets = ui.GetValue(Refs.Script.AntiAim.AtTargets[State]);
	const Pitch = ui.GetValue(Refs.Script.AntiAim.Pitch[State]);
	const YawType = ui.GetValue(Refs.Script.AntiAim.YawType[State]);
	const YawDefault = ui.GetValue(Refs.Script.AntiAim.Yaw[State]);
	const YawRight = ui.GetValue(Refs.Script.AntiAim.YawRight[State]);
	const YawLeft = ui.GetValue(Refs.Script.AntiAim.YawLeft[State]);
	const YawJitter = ui.GetValue(Refs.Script.AntiAim.YawJitter[State]);
	const JitterEnable = ui.GetValue(Refs.Script.AntiAim.JitterEnable[State]);
	const YawModifier = ui.GetValue(Refs.Script.AntiAim.YawModifier[State]);
	const YawSpin = ui.GetValue(Refs.Script.AntiAim.YawSpin[State]);
	const YawSpeedSpin = ui.GetValue(Refs.Script.AntiAim.YawSpeedSpin[State]);
	const YawOffsetSpin	= ui.GetValue(Refs.Script.AntiAim.YawOffsetSpin[State]);
	const YawRange = ui.GetValue(Refs.Script.AntiAim.YawRange[State]);
	const YawRandomMin = ui.GetValue(Refs.Script.AntiAim.YawRandomMin[State]);
	const YawRandomMax = ui.GetValue(Refs.Script.AntiAim.YawRandomMax[State]);
	const AvoidOverlap = ui.GetMultiDropdown(Refs.Script.AntiAim.Options[State], 0);
	const HideRealAngle = ui.GetMultiDropdown(Refs.Script.AntiAim.Options[State], 1);
	const DesyncOnShot = ui.GetMultiDropdown(Refs.Script.AntiAim.Options[State], 2);
	const DesyncType = ui.GetValue(Refs.Script.AntiAim.DesyncType[State]);
	const DesyncLimitLeft = -ui.GetValue(Refs.Script.AntiAim.DesyncLimitLeft[State]);
	const DesyncLimitRight = ui.GetValue(Refs.Script.AntiAim.DesyncLimitRight[State]);
	const DesyncRandomMin = ui.GetValue(Refs.Script.AntiAim.DesyncRandomMin[State]);
	const DesyncRandomMax = ui.GetValue(Refs.Script.AntiAim.DesyncRandomMax[State]);
	
	if (ui.GetValue(AntiAimBuilder)) {
		Context.AntiAim.RestoredOverride = false;
		Context.AntiAim.SafeHead = false;
		Context.AntiAim.AntiBackstab = false;
		
		DesyncJitter();
		UpdateBodyState(DesyncType, Context.Keybinds.Inverter ? DesyncLimitLeft : DesyncLimitRight, DesyncRandomMin, DesyncRandomMax);

		const Yaw = YawDefault;
		if (YawType == 1) {
			Yaw = GetYaw(YawLeft, YawRight);
		}
		
		ui.SetValue(Refs.Misc.Restrictions, 0);
		ui.SetValue(Refs.AntiAim.AtTargets, AtTargets);
		ui.SetValue(Refs.AntiAim.Yaw, Yaw);
		ui.SetValue(Refs.AntiAim.JitterOffset, YawJitter);
		ui.SetValue(Refs.AntiAim.Pitch, Pitch);
		ui.SetValue(Refs.AntiAim.FakeAngles, DesyncType != 0);
		ui.SetValue(Refs.AntiAim.AvoidOverlap, AvoidOverlap);
		ui.SetValue(Refs.AntiAim.HideRealAngle, HideRealAngle);
		ui.SetValue(Refs.AntiAim.DesyncOnShot, DesyncOnShot);
		ui.SetValue(Refs.AntiAim.InverterFlip, 0);

		if (Pitch == 7) {
			ui.SetValue(Refs.AntiAim.Pitch, Math.Random(0, 6));
		}

		if (JitterEnable) {
			if (YawModifier == 0) {
				const Inverter = Context.Keybinds.Inverter == 0 ? 1 : 0;
				ui.SetValue(Refs.AntiAim.Yaw, Yaw + (YawRange * Inverter));
			} else if (YawModifier == 1) {
				const Inverter = Context.Keybinds.Inverter == 0 ? 1 : -1;
				ui.SetValue(Refs.AntiAim.Yaw, Yaw + (YawRange * Inverter));
			} else if (YawModifier == 2) {
				ui.SetValue(Refs.AntiAim.Yaw, Yaw + Math.Random(YawRandomMin - YawRange, YawRandomMax + YawRange));
			}
		}

		if (YawSpin) {
			Context.AntiAim.SpinTime = Context.AntiAim.SpinTime + (1 * YawSpeedSpin);
			if (Context.AntiAim.SpinTime > YawOffsetSpin - Yaw) {
				Context.AntiAim.SpinTime = -YawOffsetSpin + (Context.AntiAim.SpinTime - YawOffsetSpin);
			}

			ui.SetValue(Refs.AntiAim.Yaw, Context.AntiAim.SpinTime)
		}

		if (ui.GetMultiDropdown(AntiAimSafeHead, 0) && Context.LocalPlayer.Knife && (Context.AntiAim.State == 8 || Context.AntiAim.State == 9 || Context.AntiAim.State == 10 && !Context.LocalPlayer.OnGround && Context.LocalPlayer.Netvars.DuckAmount)) {
			ui.SetValue(Refs.AntiAim.AtTargets, 1);
			ui.SetValue(Refs.AntiAim.Yaw, 25);
			ui.SetValue(Refs.AntiAim.FakeAngles, 1);
			ui.SetValue(Refs.AntiAim.JitterOffset, 0);
			ui.SetValue(Refs.AntiAim.DesyncOnShot, 0);
			AntiAim.SetOverride(1);
			AntiAim.SetRealOffset(-28);
			Context.AntiAim.SafeHead = true;
		}

		if (ui.GetMultiDropdown(AntiAimSafeHead, 1) && Context.LocalPlayer.Taser && (Context.AntiAim.State == 8 || Context.AntiAim.State == 9 || Context.AntiAim.State == 10 && !Context.LocalPlayer.OnGround && Context.LocalPlayer.Netvars.DuckAmount)) {
			ui.SetValue(Refs.AntiAim.AtTargets, 1);
			ui.SetValue(Refs.AntiAim.Yaw, 15);
			ui.SetValue(Refs.AntiAim.FakeAngles, 1);
			ui.SetValue(Refs.AntiAim.JitterOffset, 0);
			ui.SetValue(Refs.AntiAim.DesyncOnShot, 0);
			AntiAim.SetOverride(1);
			AntiAim.SetRealOffset(-28);
			Context.AntiAim.SafeHead = true;
		}
		
		if (ui.GetMultiDropdown(AntiAimTweaks, 1) && Context.AntiAim.Warmup) {
			ui.SetValue(Refs.AntiAim.AtTargets, 1);
			ui.SetValue(Refs.AntiAim.Yaw, 0);
			ui.SetValue(Refs.AntiAim.FakeAngles, 0);
			ui.SetValue(Refs.AntiAim.JitterOffset, 0);
			ui.SetValue(Refs.AntiAim.DesyncOnShot, 0);
			AntiAim.SetOverride(1);
			AntiAim.SetRealOffset(Math.Random(-60, 60));
			AntiAim.SetLBYOffset(Math.Random(-60, 60));
		}

		if (ui.GetValue(AntiAimCustomManuals) && Context.AntiAim.ManualYaw != 0) {
			ui.SetValue(Refs.AntiAim.Yaw, Yaw + ManualDirections[Context.AntiAim.ManualYaw]);
			ui.SetValue(Refs.AntiAim.AtTargets, 0);
		}
	
		if (ui.GetMultiDropdown(AntiAimTweaks, 2) && ShouldUseAntiBackstab()) {
			ui.SetValue(Refs.AntiAim.Yaw, 180);
			ui.SetValue(Refs.AntiAim.AtTargets, 1);
			Context.AntiAim.AntiBackstab = true;
		}

		if (Context.Keybinds.LegitAA) {
			Yaw = Yaw + 180;
			Cheat.ExecuteCommand('-use');
			ui.SetValue(Refs.AntiAim.Yaw, Yaw);
			ui.SetValue(Refs.AntiAim.AtTargets, AtTargets);
			ui.SetValue(Refs.AntiAim.Pitch, Pitch);
			if (Pitch == 7) {
				ui.SetValue(Refs.AntiAim.Pitch, Math.Random(0, 6));
			}

			if (JitterEnable) {
				if (YawModifier == 0) {
					const Inverter = Context.Keybinds.Inverter ? 1 : 0;
					ui.SetValue(Refs.AntiAim.Yaw, Yaw + (YawRange * Inverter));
				} else if (YawModifier == 1) {
					const Inverter = Context.Keybinds.Inverter ? 1 : -1;
					ui.SetValue(Refs.AntiAim.Yaw, Yaw + (YawRange * Inverter));
				} else if (YawModifier == 2) {
					ui.SetValue(Refs.AntiAim.Yaw, Yaw + Math.Random(YawRandomMin - YawRange, YawRandomMax + YawRange));
				}
			}

			if (YawSpin) {
				Context.AntiAim.SpinTime = Context.AntiAim.SpinTime + (1 * YawSpeedSpin);
				if (Context.AntiAim.SpinTime > YawOffsetSpin - Yaw) {
					Context.AntiAim.SpinTime = -YawOffsetSpin + (Context.AntiAim.SpinTime - YawOffsetSpin);
				}
	
				ui.SetValue(Refs.AntiAim.Yaw, Context.AntiAim.SpinTime)
			}
		}
	}

	if (ui.GetValue(AntiAimLegfucker) && Context.Rage.AntiPredict != true) {
		ui.SetValue(Refs.Misc.Slidewalk, Context.Globals.Tickcount % 5 > Context.LocalPlayer.ChokedCommands);
	}

	if (ui.GetValue(AntiAimAdaptiveFakelag)) {
		if ((Context.AntiAim.State == 1 || Context.AntiAim.State == 4 || Context.AntiAim.State == 5 || Context.AntiAim.State == 3) || Context.AntiAim.State == 11 && Context.LocalPlayer.Velocity < 5 || Context.LocalPlayer.Velocity < 5 && Context.LocalPlayer.OnGround || Context.Rage.ExploitCharge == 1) {
			ui.SetValue(Refs.Fakelag.Limit, 0);
			ui.SetValue(Refs.Fakelag.TriggerLimit, 0);
			ui.SetValue(Refs.Fakelag.Jitter, 0);
		} else {
			ui.SetValue(Refs.Fakelag.Limit, 13);
			ui.SetValue(Refs.Fakelag.TriggerLimit, 14);
			ui.SetValue(Refs.Fakelag.Jitter, 15);
			if (Context.AntiAim.AntiBackstab) {
				ui.SetValue(Refs.Fakelag.Limit, 13);
				ui.SetValue(Refs.Fakelag.TriggerLimit, 14);
				ui.SetValue(Refs.Fakelag.Jitter, 100);
			}
		}
	}
}

function Clamp(Value, Min, Max) {
	return Value > Max ? Max : Value < Min ? Min : Value;
}

function SmoothStep(X) {
	X = Clamp(X, 0, 1);
	return X * X * (3 - 2 * X);
}

function LerpColor(Start, End, Factor) {
	Factor = Clamp(Factor, 0, 1);
	return [
		(End[0] - Start[0]) * Factor + Start[0],
		(End[1] - Start[1]) * Factor + Start[1],
		(End[2] - Start[2]) * Factor + Start[2],
		(End[3] - Start[3]) * Factor + Start[3],
	]
}

var CurrentRealtime = 0;
function SmoothStepAnimation(Speed) {
	return {
		Value: 0,
		Speed: Speed ? Speed : 1,
		LastGetTime: 0,
		CachedResult: 0,
		Get: function() {
			if (this.LastGetTime != CurrentRealtime) {
				this.LastGetTime = CurrentRealtime;
				return (this.CachedResult = SmoothStep(this.Value));
			}

			return this.CachedResult;
		},
		Update: function(Condition) {
			const Realtime = Context.Globals.FixedRealtime;
			if (CurrentRealtime != Realtime) {
				CurrentRealtime = Realtime;
			}

			this.Value += Context.Globals.Frametime * this.Speed * (Condition ? 1 : -1);
			return (this.Value = Clamp(this.Value, 0, 1));
		},
	};
}

function Lerp(Start, End, Speed) {
	return (End - Start) * ((1 - Speed) * Context.Globals.Frametime * 85) + Start;
}

function IndicatorsType1() {
	const Screen = {
		X: Render.GetScreenSize()[0] * 0.5,
		Y: Render.GetScreenSize()[1] * 0.5,
	};

	const Scoped = Context.Animations.Scoped.Get();
	const GrenadeAlpha = Clamp(Context.Animations.NotGrenade.Get(), 0.33, 1);

	const Offsets = {
		X: Scoped * 2,
		Y: 16,
	};

	Render.Indicator = function(Alpha, Text, Color, Font) {
		if (Alpha <= 0) {
			return;
		}

		Color[3] *= Alpha;
		
		const TextSize = Render.TextSizeCustom(Text, Font);
		Render.OutlineString(Screen.X - (TextSize[0] * 0.5) * (1 - Scoped) + Offsets.X, Screen.Y + Offsets.Y, 0, Text, Color, Font);
		
		Offsets.Y += TextSize[1] * Alpha;
	};

	const State	= Context.AntiAim.States[Context.AntiAim.State];
	const LabelSize = Render.TextSizeCustom(Context.Label, Context.Fonts.SmallPixel);
	const BuildSize = Render.TextSizeCustom(Context.Build, Context.Fonts.SmallPixel);

	const margin = 2;
	const pulse = Math.abs(Math.sin(Context.Globals.FixedRealtime * 2.5));

	const width = LabelSize[0] + BuildSize[0] + margin;

	const X = Screen.X + Offsets.X - (width * 0.5) * (1 - Scoped);
	const Y = Screen.Y + Offsets.Y;
	const Color = [255, 255, 255, 255 * GrenadeAlpha];
	const LabelColor = LerpColor(Color, [238, 32, 77, 255 * GrenadeAlpha], Context.Animations.Hitted.Get());

	Render.OutlineString(X, Y, 0, Context.Label, LabelColor, Context.Fonts.SmallPixel);
	Render.OutlineString(X + LabelSize[0] + margin, Y, 0, Context.Build, [Context.Colors.MainColor[0], Context.Colors.MainColor[1], Context.Colors.MainColor[2], 255 * GrenadeAlpha * pulse], Context.Fonts.SmallPixel);
	
	Offsets.Y += LabelSize[1];
	const ExploitingColor = LerpColor([255, 0, 50, 255 * GrenadeAlpha], Color, Context.Animations.Exploiting.Get());
	const DormantColor = LerpColor([255, 255, 255, 100 * GrenadeAlpha], Color, Context.Animations.Dormant.Get());
	const PingColor = LerpColor([255, 0, 50, 255 * GrenadeAlpha], [127, 177, 26, 255 * GrenadeAlpha], Clamp(Context.LocalPlayer.Netvars.Ping / 160, 0, 1));
	const FreezeColor = LerpColor([Context.Colors.AlternativeColor[0], Context.Colors.AlternativeColor[1], Context.Colors.AlternativeColor[2], 100 * GrenadeAlpha], [Context.Colors.AlternativeColor[0], Context.Colors.AlternativeColor[1], Context.Colors.AlternativeColor[2], 255 * GrenadeAlpha], Context.Animations.NotFreeze.Get());
	const VelocityModifier = Math.floor(Context.LocalPlayer.VelocityModifier * 100) + '%';
	if (Context.AntiAim.AntiBrute) {
		State = 'BRUTE ' + State;
	}

	if (Context.AntiAim.SafeHead) {
		State = 'SAFE ' + State;
	}

	if (ui.GetMultiDropdown(AntiAimTweaks, 1) && Context.AntiAim.Warmup) {
		State = 'Warmup';
	}
	
	if (Context.AntiAim.ManualYaw != 0 && !ui.GetValue(VisualManualArrows)) {
		State = 'Manual';
	}

	if (Context.AntiAim.Freeze) {
		State = 'Freeze';
	}

	Render.Indicator(1, State.toUpperCase(), FreezeColor, Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.VelocityModifier.Get(), VelocityModifier, Color, Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.PingSpike.Get(), 'PING', PingColor, Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.Doubletap.Get(), 'DT', ExploitingColor, Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.Hideshots.Get(), 'OS', ExploitingColor, Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.Hitchance.Get(), 'HC', Color, Context.Fonts.SmallPixel);
	if (!StateOrGeneral(10)) {
		Render.Indicator(Context.Animations.Freestanding.Get(), 'FS', Color, Context.Fonts.SmallPixel);
	}

	Render.Indicator(Context.Animations.DormantAimbot.Get(), 'DA', DormantColor, Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.MinimumDamage.Get(), 'DMG', Color, Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.ForceBaim.Get(), 'BAIM', Color, Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.ForceSafe.Get(), 'SAFE', Color, Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.FakeDuck.Get(), 'DUCK', Color, Context.Fonts.SmallPixel);
}

function IndicatorsType2() {
	const Screen = {
		X: Render.GetScreenSize()[0] * 0.5,
		Y: Render.GetScreenSize()[1] * 0.5,
	};
	
	const Scoped = Context.Animations.Scoped.Get();
	const GrenadeAlpha = Clamp(Context.Animations.NotGrenade.Get(), 0.33, 1);
	
	const Offsets = {
		X: Scoped * 2,
		Y: 16,
	}

	Render.Indicator = function(Alpha, Text, Color, Font) {
		if (Alpha <= 0) {
			return;
		}

		Color[3] *= Alpha;
		
		const TextSize = Render.TextSizeCustom(Text, Font);
		Render.OutlineString(Screen.X - (TextSize[0] * 0.5) * (1 - Scoped) + Offsets.X, Screen.Y + Offsets.Y, 0, Text, Color, Font);
		
		Offsets.Y += TextSize[1] * Alpha;
	};
	
	const Text = Context.Label.toLowerCase() + 'tech';
	const X = Screen.X + Offsets.X - (Render.TextSizeCustom(Text, Context.Fonts.VerdanaBold)[0] * 0.5) * (1 - Scoped);
	const Y = Screen.Y + Offsets.Y;
	const Color = [Context.Colors.MainColor[0], Context.Colors.MainColor[1], Context.Colors.MainColor[2], 255 * GrenadeAlpha];
	const Color2 = [Context.Colors.AlternativeColor[0], Context.Colors.AlternativeColor[1], Context.Colors.AlternativeColor[2], 255 * GrenadeAlpha];

	Render.FadedString(X, Y, 0, Text, 5, 255, Color, Color2, Context.Fonts.VerdanaBold, 2);
	Offsets.Y += 11;

	const ExploitingColor = LerpColor([255, 0, 50, 255 * GrenadeAlpha], [255, 255, 255, 255 * GrenadeAlpha], Context.Animations.Exploiting.Get());
	const DormantColor = LerpColor([255, 255, 255, 100 * GrenadeAlpha], [255, 255, 255, 255 * GrenadeAlpha], Context.Animations.Dormant.Get());
	const VelocityModifier = Math.floor(Context.LocalPlayer.VelocityModifier * 100) + '%';
	
	Render.Indicator(Context.Animations.AntiBrute.Get(), 'BRUTE', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.SafeHead.Get(), 'SAFE HEAD', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.VelocityModifier.Get(), VelocityModifier, [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.PingSpike.Get(), 'PING', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.Doubletap.Get(), 'DT', ExploitingColor, Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.Hideshots.Get(), 'OS', ExploitingColor, Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.Freestanding.Get(), 'FS', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.Hitchance.Get(), 'HC', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.DormantAimbot.Get(), 'DA', DormantColor, Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.MinimumDamage.Get(), 'DMG', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.ForceBaim.Get(), 'BAIM', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.ForceSafe.Get(), 'SAFE', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.SmallPixel);
	Render.Indicator(Context.Animations.FakeDuck.Get(), 'DUCK', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.SmallPixel);
}

function IndicatorsType3()  {
    const Screen = {
    	X: Render.GetScreenSize()[0] * 0.5,
    	Y: Render.GetScreenSize()[1] * 0.5,
    };
    
    const Scoped = Context.Animations.Scoped.Get();
	const GrenadeAlpha = Clamp(Context.Animations.NotGrenade.Get(), 0.33, 1);
    const Offsets = {
        X: Scoped * 2,
        Y: 16,
    }

	const ExploitingColor = LerpColor([255, 0, 50, 255 * GrenadeAlpha], [255, 255, 255, 255 * GrenadeAlpha], Context.Animations.Exploiting.Get());

    Render.Indicator = function(Alpha, Text, Color, Font, NotExploiting) {
        if (Alpha <= 0) {
            return;
        }

        Color[3] *= Alpha;

        const TextSize = Render.TextSizeCustom(Text, Font);
		
        if (NotExploiting && Context.Rage.ExploitCharge != 1) {
            Render.FadedString(Screen.X - (TextSize[0] * 0.5) * (1 - Scoped) + Offsets.X, Screen.Y + Offsets.Y, 0, Text, 2, 200, Color, [255, 0, 50, 0], Font, 1);
        }

        Render.ShadowStringCustom(Screen.X - (TextSize[0] * 0.5) * (1 - Scoped) + Offsets.X, Screen.Y + Offsets.Y, 0, Text, Color, Font, 1);

    
        Offsets.Y += TextSize[1] * Alpha;
    };

    const Text =  Context.Label.toLowerCase() + '.tech';
	const Color = [Context.Colors.MainColor[0], Context.Colors.MainColor[1], Context.Colors.MainColor[2], 255 * GrenadeAlpha];
	const Color2 = [Context.Colors.AlternativeColor[0], Context.Colors.AlternativeColor[1], Context.Colors.AlternativeColor[2], 255 * GrenadeAlpha];
    const X = Screen.X + Offsets.X - (Render.TextSizeCustom(Text, Context.Fonts.VerdanaBold)[0] * 0.5) * (1 - Scoped);
    const Y = Screen.Y + Offsets.Y;

    Render.FadedString(X, Y, 0, Text, 5, 510, Color, Color2, Context.Fonts.VerdanaBold, 2);
    Offsets.Y += 11;

	const DormantColor = LerpColor([255, 255, 255, 100 * GrenadeAlpha], [255, 255, 255, 255 * GrenadeAlpha], Context.Animations.Dormant.Get());
	const VelocityModifier = Math.floor(Context.LocalPlayer.VelocityModifier * 100) + '%';

    Render.Indicator(Context.Animations.AntiBrute.Get(), 'anti-brute', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.Verdana);
    Render.Indicator(Context.Animations.SafeHead.Get(), 'safe', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.Verdana);
    Render.Indicator(Context.Animations.VelocityModifier.Get(), "velocity: " + VelocityModifier, [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.Verdana);
    Render.Indicator(Context.Animations.Doubletap.Get(), 'doubletap', ExploitingColor, Context.Fonts.Verdana, true);
    Render.Indicator(Context.Animations.Hideshots.Get(), 'onshot', ExploitingColor, Context.Fonts.Verdana, true);
    Render.Indicator(Context.Animations.ForceBaim.Get(), 'baim', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.Verdana);
    Render.Indicator(Context.Animations.ForceSafe.Get(), 'safepoint', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.Verdana);
    Render.Indicator(Context.Animations.DormantAimbot.Get(), 'dormant', DormantColor, Context.Fonts.Verdana);
    Render.Indicator(Context.Animations.Freestanding.Get(), 'freestanding', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.Verdana);
    Render.Indicator(Context.Animations.MinimumDamage.Get(), 'mindamage', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.Verdana);
    Render.Indicator(Context.Animations.Hitchance.Get(), 'hitchance', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.Verdana);
    Render.Indicator(Context.Animations.PingSpike.Get(), 'pingspike', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.Verdana);
	Render.Indicator(Context.Animations.FakeDuck.Get(), 'fakeduck', [255, 255, 255, 255 * GrenadeAlpha], Context.Fonts.Verdana);
}

function SkeetIndicators() {
	const Screen = {
		X: 15,
		Y: Render.GetScreenSize()[1] * 0.707,
	};

	Render.Indicator = function(Condition, Text, Color, Font) {
		if (!Condition) {
			return;
		}
		
		const TextSize = Render.TextSizeCustom(Text, Font);

		const Size = {
			X: TextSize[0] * 0.5,
			Y: TextSize[1] + 4,
		};

		Screen.Y -= Size.Y;

		Render.GradientRect(Screen.X, Screen.Y, Size.X + 10, Size.Y, 1, [0, 0, 0, 0], [0, 0, 0, 40]);
		Render.GradientRect(Screen.X + 10 + Size.X, Screen.Y, Size.X + 20, Size.Y, 1, [0, 0, 0, 40], [0, 0, 0, 0]);
		
		Render.ShadowStringCustom(Screen.X + 15, Screen.Y + Size.Y * 0.5 - TextSize[1] * 0.5, 0, Text, Color, Font, 0.5);

		Screen.Y -= 8;
	};

	const Color = [200, 200, 200, 255];
	const Exploiting = Context.Rage.ExploitCharge == 1;
	const Exploit = Context.LocalPlayer.CanFire && Exploiting ? Color : [255, 0, 50, 255];
	const Lagcomp = Context.LocalPlayer.LagComp.Broken ? Color : [255, 0, 50, 255];
	const Dormant = Context.Rage.ClosestTarget && Entity.IsDormant(Context.Rage.ClosestTarget) ? Color : [255, 0, 50, 255];
	const PingColor = LerpColor([255, 0, 50, 255], [158, 196, 30, 255], Clamp(Context.LocalPlayer.Netvars.Ping / 160, 0, 1));
	const C4 = Entity.GetEntitiesByClassID(128)[0];
	const Bombsite = '';
 
	Render.Indicator(Context.Keybinds.PingSpike && Context.LocalPlayer.Alive, 'PING', PingColor, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.Doubletap && !Context.Keybinds.Fakeduck && Context.LocalPlayer.Alive, 'DT', Exploit, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.Hideshots && !Context.Keybinds.Fakeduck && Context.LocalPlayer.Alive, 'OSAA', Exploit, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.DormantAimbot && Context.LocalPlayer.Alive, 'DA', Dormant, Context.Fonts.Calibri);
	
	if (ui.GetValue(VisualShotsCounter)) {
		const Fraction = 0;
		
		if (Context.Rage.Shots.Fired > 0) {
			Fraction = Context.Rage.Shots.Registered / Context.Rage.Shots.Fired;
		}
		
		const Percent = Math.round(Fraction * 100);
		if (Percent > 100) {
			Percent = 100;
		}

		Render.Indicator(Percent >= 0, '{0}%'.format(Percent), Color, Context.Fonts.Calibri);
	}
	
	Render.Indicator(Context.Keybinds.Fakeduck && Context.LocalPlayer.Alive, 'DUCK', Color, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.ForceSafe && Context.LocalPlayer.Alive, 'SAFE', Color, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.ForceBaim && Context.LocalPlayer.Alive, 'BODY', Color, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.MinimumDamage && Context.LocalPlayer.Alive, 'MD', Color, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.HitchanceOverride && Context.LocalPlayer.Alive, 'HC', Color, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.Freestanding && Context.LocalPlayer.Alive, 'FS', Color, Context.Fonts.Calibri);
	if (ui.GetValue(VisualSkeetLC)) {
		Render.Indicator(!Context.LocalPlayer.OnGround && !Exploiting && Context.LocalPlayer.Alive, 'LC', Lagcomp, Context.Fonts.Calibri);
	}
	
	if (C4 && !Entity.GetProp(C4, 'DT_PlantedC4', 'm_bBombDefused')) {
		const DefuseStart = Entity.GetProp(C4, 'CPlantedC4', 'm_hBombDefuser') != 'm_hBombDefuser';
		const DefuseLenght = Entity.GetProp(C4, 'CPlantedC4', 'm_flDefuseLength');
		const DefuseCountDown = Entity.GetProp(C4, 'CPlantedC4', 'm_flDefuseCountDown');
		const DefuseTimer = DefuseStart ? (DefuseCountDown - Context.Globals.ServerTime) : -1;
		Bombsite = Entity.GetProp(C4, 'CPlantedC4', 'm_nBombSite') == 0 ? 'A' : 'B';
		const TimeRemaining = (Entity.GetProp(C4, 'DT_PlantedC4', 'm_flC4Blow') - Context.Globals.ServerTime);
		Render.Indicator(TimeRemaining >= 0, '{0} - {1}s'.format(Bombsite, TimeRemaining.toFixed(1)), Color, Context.Fonts.Calibri);
		if (DefuseTimer > 0) {
			const DefuseBarColor = TimeRemaining >= DefuseTimer ? [58, 191, 54, 165] : [252, 18, 19, 125];
			const BarLenght = Render.GetScreenSize()[1] / DefuseLenght * DefuseTimer;
 
			Render.FilledRect(0, 0, 16, Render.GetScreenSize()[1], [25, 25, 25, 160]);
			Render.RectOutline(0, 0, 16, Render.GetScreenSize()[1], [25, 25, 25, 160]);
			Render.FilledRect(0, 0, 16, Math.round(Render.GetScreenSize()[1] - BarLenght), DefuseBarColor);
		} 
	}
}

function AnimatedSkeetIndicators() {
	const Screen = {
		X: 15,
		Y: Render.GetScreenSize()[1] * 0.707,
	};

	Render.Indicator = function(Condition, Text, Color, Font) {
		if (!Condition) {
			return;
		}
		
		const TextSize = Render.TextSizeCustom(Text, Font);
		const Size = {
			X: TextSize[0] * 0.5,
			Y: TextSize[1] + 4,
		};

		Screen.Y -= Size.Y;

		Render.GradientRect(Screen.X, Screen.Y, Size.X + 10, Size.Y, 1, [0, 0, 0, 0], [0, 0, 0, 40]);
		Render.GradientRect(Screen.X + 10 + Size.X, Screen.Y, Size.X + 20, Size.Y, 1, [0, 0, 0, 40], [0, 0, 0, 0]);
		
		Render.ShadowStringCustom(Screen.X + 15, Screen.Y + Size.Y * 0.5 - TextSize[1] * 0.5, 0, Text, Color, Font, 0.5);

		Screen.Y -= 8;
	};

	const Color = [200, 200, 200, 255];
	const Exploiting = Context.Rage.ExploitCharge == 1;
	const Lagcomp = LerpColor([255, 0, 50, 255], Color, Context.Animations.LagComp.Get());
	const PingColor = LerpColor([255, 0, 50, 255], [158, 196, 30, 255], SmoothStep(Context.Animations.PingColor));
	const ExploitColor = LerpColor([255, 0, 50, 255], Color, Context.Animations.Exploiting.Get());
	const DormantColor = LerpColor([255, 0, 50, 255], Color, Context.Animations.Dormant.Get());
	const C4 = Entity.GetEntitiesByClassID(128)[0];
	const Bombsite = '';

	Render.Indicator(Context.Keybinds.PingSpike && Context.LocalPlayer.Alive, 'PING', PingColor, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.Doubletap && !Context.Keybinds.Fakeduck && Context.LocalPlayer.Alive, 'DT', ExploitColor, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.Hideshots && !Context.Keybinds.Fakeduck && Context.LocalPlayer.Alive, 'OSAA', ExploitColor, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.DormantAimbot && Context.LocalPlayer.Alive, 'DA', DormantColor, Context.Fonts.Calibri);
	
	if (ui.GetValue(VisualShotsCounter)) {
		const Fraction = 0;
		
		if (Context.Rage.Shots.Fired > 0) {
			Fraction = Context.Rage.Shots.Registered / Context.Rage.Shots.Fired;
		}
		
		const Percent = Math.round(Fraction * 100);
		if (Percent > 100) {
			Percent = 100;
		}

		Render.Indicator(Percent >= 0, '{0}%'.format(Percent), Color, Context.Fonts.Calibri);
	}
	
	Render.Indicator(Context.Keybinds.Fakeduck && Context.LocalPlayer.Alive, 'DUCK', Color, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.ForceSafe && Context.LocalPlayer.Alive, 'SAFE', Color, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.ForceBaim && Context.LocalPlayer.Alive, 'BODY', Color, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.MinimumDamage && Context.LocalPlayer.Alive, 'MD', Color, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.HitchanceOverride && Context.LocalPlayer.Alive, 'HC', Color, Context.Fonts.Calibri);
	Render.Indicator(Context.Keybinds.Freestanding && Context.LocalPlayer.Alive, 'FS', Color, Context.Fonts.Calibri);
	if (ui.GetValue(VisualSkeetLC)) {
		Render.Indicator(!Context.LocalPlayer.OnGround && !Exploiting && Context.LocalPlayer.Alive, 'LC', Lagcomp, Context.Fonts.Calibri);
	}

	if (C4 && !Entity.GetProp(C4, 'DT_PlantedC4', 'm_bBombDefused')) {
		const DefuseStart = Entity.GetProp(C4, 'CPlantedC4', 'm_hBombDefuser') != 'm_hBombDefuser';
		const DefuseLenght = Entity.GetProp(C4, 'CPlantedC4', 'm_flDefuseLength');
		const DefuseCountDown = Entity.GetProp(C4, 'CPlantedC4', 'm_flDefuseCountDown');
		const DefuseTimer = DefuseStart ? (DefuseCountDown - Context.Globals.ServerTime) : -1;
		Bombsite = Entity.GetProp(C4, 'CPlantedC4', 'm_nBombSite') == 0 ? 'A' : 'B';
		const TimeRemaining = (Entity.GetProp(C4, 'DT_PlantedC4', 'm_flC4Blow') - Context.Globals.ServerTime);
		Render.Indicator(TimeRemaining >= 0, '{0} - {1}s'.format(Bombsite, TimeRemaining.toFixed(1)), Color, Context.Fonts.Calibri);
		
		if (DefuseTimer > 0) {
			const DefuseBarColor = TimeRemaining >= DefuseTimer ? [58, 191, 54, 160] : [252, 18, 19, 125];
			const BarLenght = Render.GetScreenSize()[1] / DefuseLenght * DefuseTimer;
 
			Render.FilledRect(0, 0, 16, Render.GetScreenSize()[1], [25, 25, 25, 160]);
			Render.RectOutline(0, 0, 16, Render.GetScreenSize()[1], [25, 25, 25, 160]);
			Render.FilledRect(0, 0, 16, Math.round(Render.GetScreenSize()[1] - BarLenght), DefuseBarColor);
		} 
	}
}

function KeepScopeTransparancy() {
	if (!ui.GetValue(VisualKeepScopeTransparancy) || Context.LocalPlayer.Grenade) {
		if (!Context.Visuals.KeepScopeTransparancyRestored) {
			ui.SetValue(Refs.Visual.VisibleTransparency, Context.Visuals.VisibleTransparencyRestored);
			Context.Visuals.KeepScopeTransparancyRestored = true;
		}

		return;
	}

	Context.Visuals.KeepScopeTransparancyRestored = false;
	const Scoped = Context.LocalPlayer.Netvars.Scoped || Context.LocalPlayer.Netvars.ResumeZoom;
	if (ui.GetValue(Refs.Visual.VisibleOverride) != 1) {
		ui.SetValue(Refs.Visual.VisibleOverride, 1);
	}
	
	ui.SetValue(Refs.Visual.VisibleType, ui.GetValue(VisualScopeChamsType) - 1);
	Context.Visuals.LastTransparency = Lerp(Context.Visuals.LastTransparency, Scoped ? ui.GetValue(VisualScopeTransparancy) : ui.GetValue(VisualLocalTransparancy), 0.7);
	ui.SetValue(Refs.Visual.VisibleTransparency, Context.Visuals.LastTransparency);
	ui.SetValue(Refs.Visual.ScopeBlend, 0);
}

function TransparencyGrenade() {
	if (!ui.GetValue(VisualGrenadeTransparancy) || Context.Animations.Scoped.Get()) {
		if (!Context.Visuals.TransparencyGrenadeRestored) {
			ui.SetValue(Refs.Visual.VisibleTransparency, Context.Visuals.VisibleTransparencyRestored);
			Context.Visuals.TransparencyGrenadeRestored = true;
		}

		return;
	}

	Context.Visuals.TransparencyGrenadeRestored = false;
	const Grenade = Context.LocalPlayer.Grenade;
	if (ui.GetValue(Refs.Visual.VisibleOverride) != 1) {
		ui.SetValue(Refs.Visual.VisibleOverride, 1);
	}
	ui.SetValue(Refs.Visual.VisibleType, ui.GetValue(VisualGrenadeChamsType) - 1);
	Context.Visuals.LastGrenadeTransparency = Lerp(Context.Visuals.LastGrenadeTransparency, Grenade ? ui.GetValue(VisualOngrenadeTransparancy) : ui.GetValue(VisualGrenadeLocalTransparancy), 0.7);
	ui.SetValue(Refs.Visual.VisibleTransparency, Context.Visuals.LastGrenadeTransparency);
}

function ManualArrows() {
	if (!ui.GetValue(VisualManualArrows) || !ui.GetValue(AntiAimCustomManuals)) {
		return;
	}
	
	const Screen = {
		X: Render.GetScreenSize()[0] * 0.5,
		Y: Render.GetScreenSize()[1] * 0.5,
	}

	const Color = [Context.Colors.MainColor[0], Context.Colors.MainColor[1], Context.Colors.MainColor[2], 255];
	const MainColor = LerpColor(Color, [Context.Colors.MainColor[0], Context.Colors.MainColor[1], Context.Colors.MainColor[2], 100], Context.Animations.Scoped.Get())

	if (ui.GetValue(VisualManualArrowsStyle) == 0) {
		const Size = 14;
		const Offset = 44;
		
		// Left Arrow
		if (Context.AntiAim.ManualYaw === 1)	{
			const Position = [Screen.X - Offset, Screen.Y];
    	    const Point1 = [Position[0], Position[1] - Size * 0.5];
    	    const Point2 = [Position[0], Position[1] + Size * 0.5];
    	    const Point3 = [Position[0] - Size, Position[1]];
			
    	    Render.Polygon([Point1, Point2, Point3], MainColor);
		}
		// Right Arrow
		if (Context.AntiAim.ManualYaw === 2) {
			const Position = [Screen.X + Offset, Screen.Y];
			const Point1 = [Position[0], Position[1] + Size * 0.5];
			const Point2 = [Position[0], Position[1] - Size * 0.5];
			const Point3 = [Position[0] + Size, Position[1]];

			Render.Polygon([Point1, Point2, Point3], MainColor);
		}
	}
	
	if (ui.GetValue(VisualManualArrowsStyle) == 1) {
		const Offset = 40;
		const OffsetY = 11;

		// Left Arrow
		if (Context.AntiAim.ManualYaw === 1) {
			const TextSize = Render.TextSizeCustom('<', Context.Fonts.VerdanaBold2);
			Render.ShadowStringCustom(Screen.X - Offset - TextSize[0], Screen.Y - OffsetY, 0, '<', MainColor, Context.Fonts.VerdanaBold2, 0.5);
		}
		// Right Arrow
		if (Context.AntiAim.ManualYaw === 2) {
			Render.ShadowStringCustom(Screen.X + Offset, Screen.Y - OffsetY, 0, '>', MainColor, Context.Fonts.VerdanaBold2, 0.5);
		}
	}
}

function DmgIndicator() {
	if (!ui.GetValue(VisualDmgIndicator) || Context.LocalPlayer.Knife || Context.LocalPlayer.Taser || Context.LocalPlayer.Grenade) {
		return;
	}

	const Screen = {
		X: Render.GetScreenSize()[0] * 0.5 + 10,
		Y: Render.GetScreenSize()[1] * 0.5 - 20,
	}

	const CurrentDamage = Context.Keybinds.MinimumDamage ? UI.GetValue('Script items', Context.Rage.CurrentWeapon + ' DMG') : Context.Rage.MinimumDamage;
	Context.Rage.LastDamage = Lerp(Context.Rage.LastDamage, CurrentDamage, 0.5);
	const Dmg = Math.round(Context.Rage.LastDamage).toString();
	const Color = LerpColor(Context.Colors.DMGColor, Context.Colors.DMGActiveColor, Context.Animations.MinimumDamage.Get());
	Render[ui.GetValue(VisualDmgFont) ? "OutlineString" : "ShadowStringCustom"](Screen.X - Render.TextSizeCustom(Dmg, ui.GetValue(VisualDmgFont) ? Context.Fonts.SmallPixel : Context.Fonts.Verdana)[0] + (Render.TextSizeCustom(Dmg, ui.GetValue(VisualDmgFont) ? Context.Fonts.SmallPixel : Context.Fonts.Verdana)[0] * (Dmg >= 100 ? 1 : Dmg >= 10 ? 0.5 : 0)), Screen.Y, 0, Dmg, Color, ui.GetValue(VisualDmgFont) ? Context.Fonts.SmallPixel : Context.Fonts.Verdana, 1);
}

function Watermark() {
	if (ui.GetValue(VisualIndicators) > 0 || !World.GetServerString()) {
		return;
	}

	if (ui.GetValue(VisualWatermarkStyle) == 0){
		const Screen = {
			X: Render.GetScreenSize()[0] * 0.5,
			Y: Render.GetScreenSize()[1] - 25, 
		}
		
		const Text = Context.Label.toLowerCase() + 'tech';
		Render.ShadowStringCustom(Screen.X, Screen.Y, 1, Text, [230, 230, 230, 255], Context.Fonts.VerdanaBold, 0.5);
	}

	if (ui.GetValue(VisualWatermarkStyle) == 1){
		const Screen = {
			X: 45,
			Y: Render.GetScreenSize()[1] * 0.5 + 10, 
		}

		const Picture = Render.AddTexture('ot/scripts/mai.png');
		const Text = Context.Label.toUpperCase();
		const TextSize = Render.TextSizeCustom(Text, Context.Fonts.SmallPixel);
		const TextSize1 = Render.TextSizeCustom('USER - ', Context.Fonts.SmallPixel);
		const TextSize2 = Render.TextSizeCustom(Context.FixedUsername.toUpperCase() + '[', Context.Fonts.SmallPixel);
		const TextSize3 = Render.TextSizeCustom(Context.Build.toUpperCase(), Context.Fonts.SmallPixel);
		
		Render.TexturedRect(Screen.X - 35, Screen.Y - 20, 40, 40, Picture);
		Render.OutlineString(Screen.X, Screen.Y, 0, Text, [255, 255, 255, 255], Context.Fonts.SmallPixel);
		Render.OutlineString(Screen.X + TextSize[0], Screen.Y, 0, '.TECHNOLOGIES', [Context.Colors.MainColor[0], Context.Colors.MainColor[1], Context.Colors.MainColor[2], 255], Context.Fonts.SmallPixel);
		Render.OutlineString(Screen.X, Screen.Y + 10, 0, 'USER - ', [255, 255, 255, 255], Context.Fonts.SmallPixel);
		Render.OutlineString(Screen.X + TextSize1[0], Screen.Y + 10, 0, Context.FixedUsername.toUpperCase() + '[', [255, 255, 255, 255], Context.Fonts.SmallPixel);
		Render.OutlineString(Screen.X + TextSize1[0] + TextSize2[0], Screen.Y + 10, 0, Context.Build.toUpperCase(), [Context.Colors.MainColor[0], Context.Colors.MainColor[1], Context.Colors.MainColor[2], 255], Context.Fonts.SmallPixel);
		Render.OutlineString(Screen.X + TextSize1[0] + TextSize2[0] + TextSize3[0], Screen.Y + 10, 0, ']', [255, 255, 255, 255], Context.Fonts.SmallPixel);
	}	

	if (ui.GetValue(VisualWatermarkStyle) == 2){
		const Screen = {
			X: 10,
			Y: Render.GetScreenSize()[1] * 0.5 + 10, 
		}
		const Text = '>\ ' + Context.Label.toLowerCase() +' anti-aim technologies </ ~ ' + Context.FixedUsername.toLowerCase();
		Render.FadedString(Screen.X, Screen.Y, 0, Text, 3, 200, [Context.Colors.MainColor[0], Context.Colors.MainColor[1], Context.Colors.MainColor[2], 255], [11, 11, 11, 155], Context.Fonts.Verdana, 2)
	}
}

function GetClantag() {
	const Clantag = Context.Label.toLowerCase() + '.' + Context.Build.toLowerCase();
	const Length = Clantag.length + 1;
	const Sinusoid = Math.abs(Math.sin(((Context.Globals.ServerTick * Context.Globals.TickInterval) / 3) % Math.PI));
    return Clantag.substring(0, Sinusoid * Length);
}

function Clantag() {
    if (!ui.GetValue(MiscClantag) || !World.GetServerString()) {
		if (!Context.Clantag.Restored) {
			Local.SetClanTag('');
			Context.Clantag.Restored = true;
		}

		return;
    }

	if (Context.Clantag.LastTick == Context.Globals.Tickcount) {
		return;
	}

	Context.Clantag.LastTick = Context.Globals.Tickcount;

	const sClantag = GetClantag();
    if (sClantag == Context.Clantag.LastClantag) {
        return;
    }
	
    Context.Clantag.LastClantag = sClantag;
	Context.Clantag.Restored = false;

    Local.SetClanTag(sClantag);
}

function Thirdperson() {
	if (!ui.GetValue(MiscThirdperson)) {
		if (!Context.Misc.RestoredThirdperson) {
			UI.SetEnabled('Visual', 'WORLD', 'View', 'Thirdperson', true);
			ui.SetValue(Refs.Visual.Thirdperson, Context.Misc.BackupedThirdperson);	
			Context.Misc.RestoredThirdperson = true;
		}

		return;
	}

	Context.Misc.RestoredThirdperson = false;
	if (UI.IsMenuOpen()) {
		UI.SetEnabled('Visual', 'WORLD', 'View', 'Thirdperson', false);
	}

	ui.SetValue(Refs.Visual.Thirdperson, ui.GetValue(MiscThirdpersonRef));
}

const Kill = [
	[ { Text: '1 мусор учись играть', Delay: 0 } ],
	[ { Text: 'лови по чепчику мудло', Delay: 0 } ],
	[ { Text: '1', Delay: 0 }, { Text: 'owned nn', Delay: 2 } ],
	[ { Text: 'sleep', Delay: 0 } ],
	[ { Text: 'ты просто нулячий дядь', Delay: 0 } ],
	[ { Text: 'раунд за раундом падаешь чепушила', Delay: 0 }, { Text: 'хех', Delay: 0.9 } ],
	[ { Text: 'понадеялся на удачу?', Delay: 0 } ],
	[ { Text: 'спи вечным сном', Delay: 0 } ],
	[ { Text: ',kznm', Delay: 0 }, { Text: 'пиздец', Delay: 1 }, { Text: 'я тебя не видел даже', Delay: 2 } ],
	[ { Text: '1', Delay: 0 }, { Text: 'iq? nn', Delay: 1 } ],
	[ { Text: '1 сын шлюхи', Delay: 0 } ],
	[ { Text: '1', Delay: 0 }, { Text: 'x.hrf t,fyfz', Delay: 1 }, { Text: 'чюрбек ебаный куда летим', Delay: 2 } ],
	[ { Text: 'что ты щас сделал?', Delay: 0 }, { Text: 'ты опять упал?', Delay: 1 } ],
	[ { Text: 'опять умер?', Delay: 0 } ],
	[ { Text: 'шляпку поймал', Delay: 0 } ],
	[ { Text: 'ебать кого я шлепнул', Delay: 0 } ],
	[ { Text: 'обоссан', Delay: 0 } ],
	[ { Text: 'AHHAHAHHAHAHH', Delay: 0 }, { Text: '1 ДЕРЕВО ЕБАНОЕ', Delay: 1 } ],
	[ { Text: '1', Delay: 0 }, { Text: 'мать твою ебал', Delay: 2 } ],
	[ { Text: 'изи упал нищий', Delay: 0 } ],
	[ { Text: 'ёк макарек египетская сила как я зарядил тебе', Delay: 0 } ],
	[ { Text: 'ну какой же ты нищий', Delay: 0 } ],
	[ { Text: 'поймал в шляпу?', Delay: 0 } ],
	[ { Text: 'что ты делаешь?', Delay: 0 } ],
	[ { Text: 'пора ливать чмоня', Delay: 0 } ],
	[ { Text: '1', Delay: 0 }, { Text: 'что ты делаешь тупой', Delay: 1 } ],
	[ { Text: '1', Delay: 0 }, { Text: '?', Delay: 0.5 } ],
	[ { Text: 'зря ты так летишь', Delay: 0 }, { Text: 'у тебя ноль шансов убить меня', Delay: 1 } ],
	[ { Text: '1', Delay: 0 }, { Text: 'ахаха', Delay: 1 }, { Text: 'спать шлюшка', Delay: 2 } ],
	[ { Text: 'в сон нахуй', Delay: 0 } ],
	[ { Text: 'че, пососал глупый даун?', Delay: 0 } ],
];

function Trashtalk() {
	if (!ui.GetValue(MiscTrashtalk)) {
		return;
	}
	
    if (Context.NextAvailableTime > Context.Globals.Curtime) {
        return;
    }

    for (var i = Context.TrashtalkQueue.length - 1; i >= 0; i--) {
        const Phrase = Context.TrashtalkQueue[i];
        if (!Phrase) {
            Context.TrashtalkQueue.splice(i, 1);
            continue;
        }

        if (Context.Globals.Curtime < Phrase.Time) {
            continue;
        }

        Cheat.ExecuteCommand('say ' + Phrase.Text);

        Context.NextAvailableTime = Phrase.Time;
        Context.TrashtalkQueue.splice(i, 1);

        break;
    }
}

function QuickSwitch() {
	if (!ui.GetValue(MiscQuickSwitch)) {
		return;
	}

	if (Context.GrenadeThrown) {
		Context.GrenadeThrown = false;
		Cheat.ExecuteCommand("slot3");
		Cheat.ExecuteCommand("slot2");
		Cheat.ExecuteCommand("slot1");
	}
	
	if (Context.ZeusFire && Convar.GetInt('sv_infinite_ammo') != 1 && Convar.GetInt('mp_taser_recharge_time') < 0) {
		Context.ZeusFire = false;
		Cheat.ExecuteCommand("slot3");
		Cheat.ExecuteCommand("slot2");
		Cheat.ExecuteCommand("slot1");
	}
}

function HandleImportExport() {
	if (ui.GetValue(ConfigImport)) {
		ui.SetValue(ConfigImport, 0);
		ui.SetValue(ConfigExport, 0);
		ui.Import(AddonFunctions.GetClipboard());
	}

	if (ui.GetValue(ConfigExport)) {
		Cheat.ExecuteCommand('showconsole');
		ui.SetValue(ConfigImport, 0);
		ui.SetValue(ConfigExport, 0);
		ui.Export();
	}
}

function Autostrafer() {
	if (!ui.GetValue(MiscAutostraferFix)) {
		UI.SetEnabled('Misc', 'GENERAL', 'Movement', 'Turn speed', true);
		return;
	}

	if (UI.IsMenuOpen()) {
		UI.SetEnabled('Misc', 'GENERAL', 'Movement', 'Turn speed', false);
	}

	const Velocity = Context.LocalPlayer.Netvars.VecVelocity.ToArray();
	ui.SetValue(Refs.Misc.TurnSpeed, Math.sqrt(Velocity[0] ** 2 + Velocity[1] ** 2 + Velocity[2] ** 2) + ui.GetValue(MiscAutostraferModifier));
}

function AddToEventLog(Items, Time) {
	Context.Logs.push({ Items: Items, Curtime: Context.Globals.Curtime, Time: Time, Alpha: 255 });
}

function AddToCrosshairLog(Items, Time) {
	Context.CrosshairLogs.push({ Items: Items, Curtime: Context.Globals.Curtime, Time: Time, Alpha: 0 });
}

function EventLog() {
	if (Context.Logs.length <= 0) {
		return;
	}

	if (Context.Logs.length > 10) {
		Context.Logs.shift();
	}

	if (Math.abs(Context.Logs[0].Curtime - Context.Globals.Curtime) >= Context.Logs[0].Time) {
		Context.Logs[0].Alpha -= Context.Globals.Frametime * 600;
	}

	if (Math.floor(Context.Logs[0].Alpha) <= 0) {
		Context.Logs.shift();
	}

	const Offsets = {
		X: 0,
		Y: 0,
	};
	
	const Font = ui.GetValue(MiscLogsEventFont) ? Context.Fonts.VerdanaBold1 : Context.Fonts.VerdanaThin;

	for (i = 0; i < Context.Logs.length; i++) {
		const Log = Context.Logs[i];
		var TotalSize = 0;
		Offsets.X = TotalSize;
		for (var j = 0; j < Log.Items.length; j++) {
			const Item = Log.Items[j];
			const Color = Item.Color
			if (!Color) {
				Color = [255, 255, 255];
			}

			Render.ShadowStringCustom(5 + Offsets.X, 5 + 13 * i, 0, Item.Text, [Color[0], Color[1], Color[2], Log.Alpha], Font, 1);
			Offsets.X += Render.TextSizeCustom(Item.Text, Font)[0];
		}
	}
}

function CrosshairLog() {
	if (Context.CrosshairLogs.length <= 0) {
		return;
	}

	for (var i = Context.CrosshairLogs.length - 1; i >= 0; i--) {
		const Log = Context.CrosshairLogs[i];
		if (!Log) {
			Context.CrosshairLogs.splice(i, 1);
			continue;
		}

		if (Math.abs(Context.Globals.Curtime - Log.Curtime) < Log.Time) {
			if (Log.Alpha < 255) {
				Log.Alpha += Context.Globals.Frametime * 1200;
				
				if (Log.Alpha > 255) {
					Log.Alpha = 255;
				}
			} else if (Log.Alpha > 255) {
				Log.Alpha = 255;
			}
		} else {
			Log.Alpha -= Context.Globals.Frametime * 1200;
		}	
		
		if (Math.round(Log.Alpha) <= 0) {
			Context.CrosshairLogs.splice(i, 1);
		}
	}

	const Screen = {
		X: Render.GetScreenSize()[0] * 0.5,
		Y: Render.GetScreenSize()[1] * 0.5 + 240,
	};

	const Offsets = {
		X: 0,
		Y: 0,
	};
	
	for (var i = 0; i < Context.CrosshairLogs.length; i++) {
		const Log = Context.CrosshairLogs[i];

		var TotalSize = 0;
		for (var j = 0; j < Log.Items.length; j++) {
			TotalSize += Math.round(Render.TextSizeCustom(Log.Items[j].Text, Context.Fonts.VerdanaThin)[0] * 0.5);
		}

		const X = Log.Alpha / 255;
		Offsets.Y += Math.floor(13 * SmoothStep(X));
		Offsets.X = -TotalSize;

		for (var j = 0; j < Log.Items.length; j++) {
			const Item = Log.Items[j];
			if (!Item.Color) {
				Item.Color = [255, 255, 255]
			}

			Render.ShadowStringCustom(Screen.X + Offsets.X, Screen.Y + Offsets.Y, 0, Item.Text, [Item.Color[0], Item.Color[1], Item.Color[2], Log.Alpha], Context.Fonts.VerdanaThin, 1);
            Offsets.X += Render.TextSizeCustom(Item.Text, Context.Fonts.VerdanaThin)[0];
		}
	}
}

function BuyLogs() {
	if (!ui.GetValue(MiscBuyLog)) {
		return;
	}

	const Player = Entity.GetEntityFromUserID(Event.GetInt('userid'));
	if (Entity.IsTeammate(Player)) {
		return;
	}
	
	const Weapon = Event.GetString('weapon').replace('weapon_', '').replace('item_', '').replace('assaultsuit', 'kevlar + helmet').replace('hkp2000', 'p2000').replace('incgrenade', 'molotov').replace('molotov', 'molly').replace('grenade', '').replace('m4a1_silencer', 'm4a1-s');
    if (Weapon == 'unknown') {
		return;
    }

	Cheat.Log('{0} bought {1}\n'.format(Entity.GetName(Player).replace(/  /gi, '?'), Weapon));

	if (ui.GetValue(MiscLogsEvent)){
		AddToEventLog([
			{
				Text: Entity.GetName(Player).replace(/  /gi, '?').toLowerCase() + ' ',
				Color: Context.Colors.MainLogColor,
			},
			{
				Text:  'bought ',
			},
			{
				Text: Weapon,
				Color: Context.Colors.MainLogColor,
			},
		], 3);
	}

	if (ui.GetValue(MiscCrosshairLogs) && ui.GetMultiDropdown(MiscChoiceOfLogs, 0)) {
		AddToCrosshairLog([
			{
				Text: Entity.GetName(Player).replace(/  /gi, '?').toLowerCase() + ' ',
				Color: Context.Colors.MainLogColor,
			},
			{
				Text:  'bought ',
			},
			{
				Text: Weapon,
				Color: Context.Colors.MainLogColor,
			},
		], 3);
	}
}

function GetHitboxName(Hitbox) {
    return [
        'head',
        'head',
        'stomach',
        'stomach',
        'chest',
        'chest',
        'chest',
        'left leg',
        'right leg',
        'left leg',
        'right leg',
        'left leg',
        'right leg',
        'left arm',
        'right arm',
        'right arm',
        'right arm',
        'left arm',
        'left arm'
    ][Hitbox] || 'body';
}

function GetHitgroupName(Hitgroup) {
    return [
        'generic',
        'head',
        'chest',
        'stomach',
        'left arm',
        'right arm',
        'left leg',
        'right leg',
        'head'
    ][Hitgroup] || 'body';
}

function GetPrefix(Weapon) {
    if (Weapon == 'hegrenade') {
        return 'naded';
    }

    if (Weapon == 'inferno') {
        return 'burned';
    }

    if (Weapon == 'knife') {
        return 'knifed';
    }

    if (Weapon == 'taser') {
        return 'zeused';
    }

    return 'hit';
}

function HitLog() {
	if (Entity.GetEntityFromUserID(Event.GetInt('userid')) == Context.LocalPlayer.Index || Entity.GetEntityFromUserID(Event.GetInt('attacker')) != Context.LocalPlayer.Index) {
        return;
    }

    const EventData = {
        Hitgroup: GetHitgroupName(Event.GetInt('hitgroup')),
        Damage: Event.GetInt('dmg_health'),
        Health: Event.GetInt('health'),
        Weapon: Event.GetString('weapon'),
        SanitizedName: Entity.GetName(Entity.GetEntityFromUserID(Event.GetInt('userid'))).replace(/  /gi, '?').toLowerCase(),
    };

	const Remaining = '{0} remaining'.format(EventData.Health);
	if (EventData.Health <= 0) {
		Remaining = 'dead';
	}

    if (EventData.Weapon == 'smokegrenade' || EventData.Weapon == 'flashbang' || EventData.Weapon == 'decoy') {
        return;
    }

	for (var i = 0; i < Context.Rage.ShotData.length; i++) {
        const Shot = Context.Rage.ShotData[i];

        if (Context.Globals.ServerTick - Shot.Tick > (2 / Context.Globals.TickInterval)) {
            Context.Rage.ShotData.splice(i, 1);
            continue;
        }

        Shot.DidHurt = true;
    }

	if (!ui.GetValue(MiscLogs)) {
		return;
	}

    const Prefix = GetPrefix(EventData.Weapon);   
    if (Prefix != 'hit') {
		Cheat.Log('');
		Cheat.PrintColor([Context.Colors.MainLogColor[0], Context.Colors.MainLogColor[1], Context.Colors.MainLogColor[2], 255], Prefix);
		Cheat.PrintColor([255, 255, 255, 255], ' {0}'.format(EventData.SanitizedName));
		Cheat.PrintColor([255, 255, 255, 255], ' for ');
		Cheat.PrintColor([Context.Colors.MainLogColor[0], Context.Colors.MainLogColor[1], Context.Colors.MainLogColor[2], 255], EventData.Damage.toString());
		Cheat.PrintColor([255, 255, 255, 255], ' (');
		Cheat.PrintColor([Context.Colors.MainLogColor[0], Context.Colors.MainLogColor[1], Context.Colors.MainLogColor[2], 255], Remaining);
		Cheat.PrintColor([255, 255, 255, 255], ')\n');

		if (ui.GetValue(MiscLogsEvent)) {
			AddToEventLog([
				{
					Text: Prefix + ' ',
					Color: Context.Colors.MainLogColor,
				},
				{
					Text: EventData.SanitizedName + ' ',
				},
				{
					Text: 'for ',
				},
				{
					Text: EventData.Damage.toString() + ' ',
					Color: Context.Colors.MainLogColor,
				},
				{
					Text:  '(',
				},
				{
					Text: Remaining,
					Color: Context.Colors.MainLogColor,
				},
				{
					Text:  ')',
				},
			], 3);
		}

		if (ui.GetValue(MiscCrosshairLogs) && ui.GetMultiDropdown(MiscChoiceOfLogs, 1)) {
			AddToCrosshairLog([
				{
					Text: Prefix + ' ',
					Color: Context.Colors.MainLogColor,
				},
				{
					Text: EventData.SanitizedName + ' ',
				},
				{
					Text: 'for ',
				},
				{
					Text: EventData.Damage.toString() + ' ',
					Color: Context.Colors.MainLogColor,
				},
				{
					Text:  '(',
				},
				{
					Text: Remaining,
					Color: Context.Colors.MainLogColor,
				},
				{
					Text:  ')',
				},
			], 3);
		}

		return;
    }

	Context.Rage.Shots.Registered++;

    const HitboxName = GetHitboxName(Context.Rage.LastShot.Hitbox);

	Cheat.Log('');
    Cheat.PrintColor([Context.Colors.MainLogColor[0], Context.Colors.MainLogColor[1], Context.Colors.MainLogColor[2], 255], Prefix);
    Cheat.PrintColor([255, 255, 255, 255], ' {0}\'s '.format(EventData.SanitizedName));
    Cheat.PrintColor([Context.Colors.MainLogColor[0], Context.Colors.MainLogColor[1], Context.Colors.MainLogColor[2], 255], EventData.Hitgroup);
    Cheat.PrintColor([255, 255, 255, 255], ' for ');
    Cheat.PrintColor([Context.Colors.MainLogColor[0], Context.Colors.MainLogColor[1], Context.Colors.MainLogColor[2], 255], EventData.Damage.toString());
    Cheat.PrintColor([255, 255, 255, 255], ' (');
    Cheat.PrintColor([Context.Colors.MainLogColor[0], Context.Colors.MainLogColor[1], Context.Colors.MainLogColor[2], 255], Remaining);
	
	if (HitboxName != EventData.Hitgroup) {
		Cheat.PrintColor([255, 255, 255, 255], '), aimed: ');
		Cheat.PrintColor([Context.Colors.MainLogColor[0], Context.Colors.MainLogColor[1], Context.Colors.MainLogColor[2], 255], HitboxName);
		Cheat.PrintColor([255, 255, 255, 255], '(');
		Cheat.PrintColor([Context.Colors.MainLogColor[0], Context.Colors.MainLogColor[1], Context.Colors.MainLogColor[2], 255], '{0}%%'.format(Context.Rage.LastShot.Hitchance));
		Cheat.PrintColor([255, 255, 255, 255], ')\n');
	} else {
		Cheat.PrintColor([255, 255, 255, 255], ')\n');
	}

	if (ui.GetValue(MiscCrosshairLogs) && ui.GetMultiDropdown(MiscChoiceOfLogs, 1)) {
		AddToCrosshairLog([
			{
				Text: 'hit ',
				Color: Context.Colors.MainLogColor,
			},
			{
				Text: EventData.SanitizedName + '\'s ',
			},
			{
				Text: EventData.Hitgroup + ' ',
				Color: Context.Colors.MainLogColor,
			},
			{
				Text: 'for ',
			},
			{
				Text: EventData.Damage.toString() + ' ',
				Color: Context.Colors.MainLogColor,
			},
			{
				Text:  '(',
			},
			{
				Text: Remaining,
				Color: Context.Colors.MainLogColor,
			},
			{
				Text:  ')',
			},
		], 3);
	}

	if (ui.GetValue(MiscLogsEvent)) {
		if (HitboxName != EventData.Hitgroup) {
			AddToEventLog([
				{
					Text: 'hit ',
					Color: Context.Colors.MainLogColor,
				},
				{
					Text: EventData.SanitizedName + '\'s ',
				},
				{
					Text: EventData.Hitgroup + ' ',
					Color: Context.Colors.MainLogColor,
				},
				{
					Text: 'for ',
				},
				{
					Text: EventData.Damage.toString() + ' ',
					Color: Context.Colors.MainLogColor,
				},
				{
					Text:  '(',
				},
				{
					Text: Remaining,
					Color: Context.Colors.MainLogColor,
				},
				{
					Text:  '),',
				},
				{
					Text:  ' aimed: ',
				},
				{
					Text: HitboxName,
					Color: Context.Colors.MainLogColor,
				},
				{
					Text:  '(',
				},
				{
					Text: '{0}%'.format(Context.Rage.LastShot.Hitchance),
					Color: Context.Colors.MainLogColor,
				},
				{
					Text:  ')',
				},
			], 3);
		} else {
			AddToEventLog([
				{
					Text: 'hit ',
					Color: Context.Colors.MainLogColor,
				},
				{
					Text: EventData.SanitizedName + '\'s ',
				},
				{
					Text: EventData.Hitgroup + ' ',
					Color: Context.Colors.MainLogColor,
				},
				{
					Text: 'for ',
				},
				{
					Text: EventData.Damage.toString() + ' ',
					Color: Context.Colors.MainLogColor,
				},
				{
					Text:  '(',
				},
				{
					Text: Remaining,
					Color: Context.Colors.MainLogColor,
				},
				{
					Text:  ')',
				},
			], 3);
		}
	}
}

function CalculateYaw(Start, End) {
	const Difference = Start.Sub(End);
	const Hyp = Difference.Length2D();
    
    const Yaw = Math.atan(Difference.Y / Difference.X) * (180 / Math.PI);
    if (Math.atan(Difference.Z / Hyp) * (180 / Math.PI) >= 0) {
        return Yaw + 180;
    }

    return Yaw;
}

function CalculatePitch(Start, End) {
	const Difference = Start.Sub(End);
	const Hyp = Difference.Length2D();    
    return Math.atan(Difference.Z / Hyp) * (180 / Math.PI);
}

function CalculateAngle(Start, End) {
	const Difference = Start.Sub(End);
	const Hyp = Difference.Length2D();
    
    const Yaw = Math.atan(Difference.Y / Difference.X) * (180 / Math.PI);
    const Pitch = Math.atan(Difference.Z / Hyp) * (180 / Math.PI);
	if (Pitch >= 0) {
        return Yaw + 180 + Pitch;
    }

    return Yaw + Pitch;
}

function NormalizeAngle(Angle) {
	Angle %= 360;

	if (Angle > 180) {
		Angle -= 360;
	} 

	if (Angle < -180) {
		Angle += 360;
	}

	return Angle;
}

function GetReason(Shot) {
    if (!Entity.IsAlive(Shot.Target)) {
        return 'ping (target death)';
    }

    if (!Context.LocalPlayer.Alive && !Shot.HasBeenRegistered) {
        return 'ping (local death)';
    }

	if (!Shot.HasBeenFired || !Shot.HasBeenRegistered) {
		return 'server rejection';
	}

	if (!Context.Addon.Loaded) {
		return '?';
	}

	if (!Cheat.LastMisses) {
		Cheat.LastMisses = [];
	}

	if (!Cheat.LastMisses[Shot.Target]) {
		Cheat.LastMisses[Shot.Target] = 0;
	}

	const Misses = AddonFunctions.GetMisses(Shot.Target);
	const LastMisses = Misses > 0 ? Cheat.LastMisses[Shot.Target] : 0;

	Cheat.LastMisses[Shot.Target] = Misses;
	
	if (Misses != LastMisses) {
		return 'resolver';
	}

    return 'spread';
}

function MissLog() {
	if (!ui.GetValue(MiscLogs)) {
		return;
	}

	for (var i = Context.Rage.ShotData.length - 1; i >= 0; i--) {
        const Shot = Context.Rage.ShotData[i];
        if (!Shot || Shot.DidHurt) {
            Context.Rage.ShotData.splice(i, 1);
            continue;
        }

        if ((!Shot.HasBeenFired && !Shot.HasBeenRegistered) && Math.abs(Shot.Tick - Context.Globals.ServerTick) < (1 / Context.Globals.TickInterval)) {
            continue;
        }

        const Reason = GetReason(Shot);
        const SanitizedName = Entity.GetName(Shot.Target).replace(/  /gi, '?').toLowerCase();
        const Hitbox = GetHitboxName(Shot.Hitbox);
		const ServerYaw = CalculateAngle(Shot.Start, Shot.Impacts[Shot.Impacts.length - 1 >= 0 ? Shot.Impacts.length - 1 : 0]);
		const ClientYaw = CalculateAngle(Shot.Start, Shot.End);

		const Innacuracy = Clamp(NormalizeAngle(ClientYaw - ServerYaw) / 45, -1, 1).toFixed(2);
		Cheat.Log('', true);
		Cheat.PrintColor([Context.Colors.MainAltLogColor[0], Context.Colors.MainAltLogColor[1], Context.Colors.MainAltLogColor[2], 255], 'missed ');
		Cheat.PrintColor([255, 255, 255, 255], '{0}\'s '.format(SanitizedName));
		Cheat.PrintColor([Context.Colors.MainAltLogColor[0], Context.Colors.MainAltLogColor[1], Context.Colors.MainAltLogColor[2], 255], Hitbox);
		Cheat.PrintColor([255, 255, 255, 255], ' due to ');
		if (Reason != 'spread') {
			Cheat.PrintColor([Context.Colors.MainAltLogColor[0], Context.Colors.MainAltLogColor[1], Context.Colors.MainAltLogColor[2], 255], Reason + ' ');
			Cheat.PrintColor([255, 255, 255, 255], 'hc: ');
			Cheat.PrintColor([255, 255, 255, 255], '(');
			Cheat.PrintColor([Context.Colors.MainAltLogColor[0], Context.Colors.MainAltLogColor[1], Context.Colors.MainAltLogColor[2], 255], '{0}%%'.format(Context.Rage.LastShot.Hitchance));
			Cheat.PrintColor([255, 255, 255, 255], ')\n');
		} else {	
			Cheat.PrintColor([Context.Colors.MainAltLogColor[0], Context.Colors.MainAltLogColor[1], Context.Colors.MainAltLogColor[2], 255], Reason + ' ');
			Cheat.PrintColor([255, 255, 255, 255], '(');
			Cheat.PrintColor([Context.Colors.MainAltLogColor[0], Context.Colors.MainAltLogColor[1], Context.Colors.MainAltLogColor[2], 255], Innacuracy + '°');
			Cheat.PrintColor([255, 255, 255, 255], ') ');
			Cheat.PrintColor([255, 255, 255, 255], 'hc: ');
			Cheat.PrintColor([255, 255, 255, 255], '(');
			Cheat.PrintColor([Context.Colors.MainAltLogColor[0], Context.Colors.MainAltLogColor[1], Context.Colors.MainAltLogColor[2], 255], '{0}%%'.format(Context.Rage.LastShot.Hitchance));
			Cheat.PrintColor([255, 255, 255, 255], ')\n');
		}
		
		if (ui.GetValue(MiscLogsEvent)) {
			if (Reason != 'spread'){
				AddToEventLog([
					{
						Text: 'missed ',
						Color: Context.Colors.MainAltLogColor,
					},
					{
						Text: '{0}\'s '.format(SanitizedName),
					},
					{
						Text: Hitbox + ' ',
						Color: Context.Colors.MainAltLogColor,
					},
					{
						Text: 'due to ',
					},
					{
						Text: Reason + ' ',
						Color: Context.Colors.MainAltLogColor,
					},
					{
						Text:  'hc: (',
					},
					{
						Text: '{0}%'.format(Context.Rage.LastShot.Hitchance),
						Color: Context.Colors.MainAltLogColor,
					},
					{
						Text:  ')',
					},
				], 5);
			} else {
				AddToEventLog([
					{
						Text: 'missed ',
						Color: Context.Colors.MainAltLogColor,
					},
					{
						Text: '{0}\'s '.format(SanitizedName),
					},
					{
						Text: Hitbox + ' ',
						Color: Context.Colors.MainAltLogColor,
					},
					{
						Text: 'due to ',
					},
					{
						Text: 'spread',
						Color: Context.Colors.MainAltLogColor,
					},
					{
						Text: ' (',
					},
					{
						Text: Innacuracy,
						Color: Context.Colors.MainAltLogColor,
					},
					{
						Text: ') ',
					},
					{
						Text:  'hc: (',
					},
					{
						Text: '{0}%'.format(Context.Rage.LastShot.Hitchance),
						Color: Context.Colors.MainAltLogColor,
					},
					{
						Text:  ')',
					},
				], 5);
			}
		}

		if (ui.GetValue(MiscCrosshairLogs) && ui.GetMultiDropdown(MiscChoiceOfLogs, 1)) {
			AddToCrosshairLog([
				{
					Text: 'missed ',
					Color: Context.Colors.MainAltLogColor,
				},
				{
					Text: '{0}\'s '.format(SanitizedName),
				},
				{
					Text: Hitbox + ' ',
					Color: Context.Colors.MainAltLogColor,
				},
				{
					Text: 'due to ',
				},
				{
					Text: Reason,
					Color: Context.Colors.MainAltLogColor,
				}
			], 3);
		}

        Context.Rage.ShotData.splice(i, 1);
    }
}

function UpdateSpectators() {
	Context.SpectatorsList = [];

    const Players = Context.Players;
    for (i = 0; i < Players.length; i++) {
        const Player = Players[i];
        if (!Player || Entity.GetProp(Player, 'DT_BasePlayer', 'm_hObserverTarget') == 'm_hObserverTarget' || Entity.IsDormant(Player)) {
            continue;
        }

        const Observer = Entity.GetProp(Player, 'DT_BasePlayer', 'm_hObserverTarget');
        if (Observer != Context.LocalPlayer.Index) {
            continue;
        }

        Context.SpectatorsList.push(Entity.GetName(Player).replace(/  /gi, '?'));
    }
}

function FivehundredDollarsSpectators() {
	if (!ui.GetValue(Visual500Spectators) || !World.GetServerString()) {
		return;
	}

	const Screen = {
		X: Render.GetScreenSize()[0] - 10,
		Y: 5,
	}
	
	const Spectators = Context.SpectatorsList;
	for (var i = 0; i < Spectators.length; i++) {
		const Spectator = Spectators[i];
		const TextSize = Render.TextSizeCustom(Spectator, Context.Fonts.Verdana);
		
		Render.ShadowStringCustom(Screen.X - TextSize[0], Screen.Y, 0, Spectator, [255, 255, 255, 200], Context.Fonts.Verdana, 1);
		
		Screen.Y += TextSize[1] + 5;
	}
}

function HitgroupToHitbox(Hitgroup) {
    return [3, 0, 5, 2, 18, 16, 7, 8, 3][Hitgroup];
}

function SmartBuyBot() {
	if (!ui.GetValue(MiscSmartBuybot) || !World.GetServerString()) {
		if (!Context.LocalPlayer.RestoredBuy) {
			ui.SetValue(Refs.Misc.BuyBot, 0);
			Context.LocalPlayer.RestoredBuy = true;
		}
		
		return;
	}

	if (World.GetServerString() == '46.174.50.242:1338' || World.GetServerString() == '46.174.50.242:1337') {
		ui.SetValue(Refs.Misc.BuyBot, 0);
		return;
	}

	Context.LocalPlayer.RestoredBuy = false;

	if (Context.LocalPlayer.Money <= 4000) {
		ui.SetValue(Refs.Misc.BuyBot, 0);
	} else {
		ui.SetValue(Refs.Misc.BuyBot, 1);
	}
}

function KibitWorldMarker() {
	if (!ui.GetValue(VisualKibitMarker)) {
		return;
	}

	Render.Indicator = function(Data) {
		if (!Data.Position || !Data.Time) {
			return;
		}

		const W2S = Render.WorldToScreen(Data.Position);
		if (!W2S) {
			return;
		}

		const Screen = {
			X: W2S[0],
			Y: W2S[1],
		};
		
		const Alpha = Clamp(SmoothStep((Data.Time + 3 - Context.Globals.Curtime) / 0.25) * Context.Colors.MainKibit[3], 0, Context.Colors.MainKibit[3]);

		const Color = [40, 255, 255, Alpha]
		const Color1 = [0, 255, 100, Alpha]

		if (ui.GetValue(VisualKibitMarkerColor)) {
			Color = [Context.Colors.MainKibit[0], Context.Colors.MainKibit[1], Context.Colors.MainKibit[2], Alpha];
			Color1 = [Context.Colors.AltKibit[0], Context.Colors.AltKibit[1], Context.Colors.AltKibit[2], Alpha];
		}

		const Size = 5;
		Render.FilledRect(Screen.X - Size, Screen.Y - 1, Size * 2, 2, Color);
		Render.FilledRect(Screen.X - 1, Screen.Y - Size, 2, Size * 2, Color1);		
	};

	for (var i = Context.KibitWorldMarkerData.length - 1; i >= 0; i--) {
		if (!Context.KibitWorldMarkerData[i]) {
			continue;
		}
		
		Render.Indicator(Context.KibitWorldMarkerData[i]);

		if (Math.abs(Context.KibitWorldMarkerData[i].Time - Context.Globals.Curtime) >= 3) {
			Context.KibitWorldMarkerData.splice(i, 1);
		}
	}
}

function LineBulletTracer() {
	if (!ui.GetValue(VisualBulletTracer)) {
		return;
	}

	Render.Indicator = function(Data) {
		if (!Data.Time) {
			return;
		}

		const W2S = Render.WorldToScreen([Data.Impacts.X, Data.Impacts.Y, Data.Impacts.Z]);
		const W2SEye = Render.WorldToScreen(Data.Eye);
		const Screen = {
			X: W2S[0],
			Y: W2S[1],
			Z: W2S[2],
		}

		const Alpha = Clamp(SmoothStep((Data.Time + 4 - Context.Globals.Curtime) / 0.25) * Context.Colors.BulletTracer[3], 0, Context.Colors.BulletTracer[3]);
		if (W2SEye[2] == 1 && Screen.Z == 1) {
			Render.Line(W2SEye[0], W2SEye[1], Screen.X, Screen.Y, [Context.Colors.BulletTracer[0], Context.Colors.BulletTracer[1], Context.Colors.BulletTracer[2], Alpha]);
		}
	}

	for (var i = Context.LineBulletTracerData.length - 1; i >= 0; i--) {
		if (!Context.LineBulletTracerData[i]) {
			continue;
		}
		
		Render.Indicator(Context.LineBulletTracerData[i]);
		
		if (Math.abs(Context.LineBulletTracerData[i].Time - Context.Globals.Curtime) >= 4) {
			Context.LineBulletTracerData.splice(i, 2);
		}
	}
}

function CrosshairHitmarker() {
	if (!ui.GetValue(VisualCrosshairHitmarker) || !Context.LocalPlayer.Alive) {
		return;
	}
	
	if (!Context.Crosshairhitmarker.Time || !Context.Crosshairhitmarker.ShouldDraw) {
		return;
	}

	const Screen = {
		X: Render.GetScreenSize()[0] * 0.5,
		Y: Render.GetScreenSize()[1] * 0.5,
	}

	const Size = 5;
	const Alpha = Clamp(SmoothStep((Context.Crosshairhitmarker.Time + 1 - Context.Globals.Curtime) / 0.50) * Context.Colors.CrosshairColor[3], 0, Context.Colors.CrosshairColor[3]);
	if (Math.abs(Context.Crosshairhitmarker.Time - Context.Globals.Curtime) >= 1) {
		return;
	}
	
    Render.Line(Screen.X - Size * 2, Screen.Y - Size * 2, Screen.X - Size, Screen.Y - Size, [Context.Colors.CrosshairColor[0], Context.Colors.CrosshairColor[1], Context.Colors.CrosshairColor[2], Alpha]);
    Render.Line(Screen.X + Size * 2, Screen.Y + Size * 2, Screen.X + Size, Screen.Y + Size, [Context.Colors.CrosshairColor[0], Context.Colors.CrosshairColor[1], Context.Colors.CrosshairColor[2], Alpha]);
    Render.Line(Screen.X + Size * 2, Screen.Y - Size * 2, Screen.X + Size, Screen.Y - Size, [Context.Colors.CrosshairColor[0], Context.Colors.CrosshairColor[1], Context.Colors.CrosshairColor[2], Alpha]);
    Render.Line(Screen.X - Size * 2, Screen.Y + Size * 2, Screen.X - Size, Screen.Y + Size, [Context.Colors.CrosshairColor[0], Context.Colors.CrosshairColor[1], Context.Colors.CrosshairColor[2], Alpha]);
}

function AspectRatio() {
	if (!ui.GetValue(MiscAspectRatio)) {
		if (!Context.Misc.RestoredAspectratio) {
			Convar.SetFloat('r_aspectratio', Context.Misc.BackupedAspectratio);
			Context.Misc.RestoredAspectratio = true;
		}

		return;
	}
	
	Context.Misc.RestoredAspectratio = false;
	Context.Misc.LastAspectratio = Lerp(Context.Misc.LastAspectratio, ui.GetValue(MiscAspectRatioRef), 0.9);
	if (ui.GetValue(MiscAspectRatioRef) == 0.00) {
		Context.Misc.LastAspectratio = 0;
	}

	Convar.SetFloat('r_aspectratio', Context.Misc.LastAspectratio);
}

function Chat() {
	if (!ui.GetValue(MiscEnemyChatViewer)) {
		return;
	}

	const Player = Entity.GetEntityFromUserID(Event.GetInt('userid'));
	if (Entity.IsTeammate(Player)) {
		return;
	}

	const Team = Entity.GetProp(Player, 'DT_BaseEntity', 'm_iTeamNum');
	if (Team != 1 && Team != 2 && Team != 3) {
		return;
	}

	const TeamColor = '\t \x01';
	if (Team == 3) {
		TeamColor = '\t \x0b';
	}  
	if (Team == 2) {
		TeamColor = '\t \x10';
	}

	const Text = Event.GetString('text');
	const Name = Entity.GetName(Player).replace(/  /gi, '?');
	const DeadPrefix = !Entity.IsAlive(Player) && !Entity.IsDormant(Player) ? '*DEAD*' : '';
	
	Cheat.PrintChat(TeamColor + DeadPrefix + ' ' + Name + ' : \x01 ' + Text);
}

function MusicKit() {
	if (!ui.GetValue(MiscMusicKit) || !Context.LocalPlayer.Alive) {
		Entity.SetProp(Context.LocalPlayer.Index, "CCSPlayerResource", "m_nMusicID", 0);
		return;
	}

	if (!UI.IsMenuOpen()) {
		return;
	}

	Entity.SetProp(Context.LocalPlayer.Index, "CCSPlayerResource", "m_nMusicID", ui.GetValue(MiscMusicKitSet));
}

function RagebotFire() {
	try {
		Context.Rage.LastShot.Hitchance = Event.GetInt('hitchance');
		Context.Rage.LastShot.Safe = !!Event.GetInt('safepoint');
		Context.Rage.LastShot.Hitbox = Event.GetInt('hitbox');
		Context.Rage.LastShot.Exploit = Event.GetInt('exploit');
		Context.Rage.LastShot.Target = Event.GetInt('target_index');
		Context.Rage.LastShotTick = Context.Globals.Tickcount;

		Context.Rage.Shots.Fired++;
	
		Context.Rage.ShotData.push({
			End: Vector(Entity.GetHitboxPosition(Context.Rage.LastShot.Target, Context.Rage.LastShot.Hitbox)),
			Tick: Context.Globals.ServerTick,
			Start: Context.LocalPlayer.EyePosition,
			Exploit: Context.Rage.LastShot.Exploit,
			Target: Context.Rage.LastShot.Target,
			Hitchance: Context.Rage.LastShot.Hitchance,
			Safe: Context.Rage.LastShot.Safe,
			Hitbox: Context.Rage.LastShot.Hitbox,
			HasBeenRegistered: false,
			HasBeenFired: false,
			DidHurt: false,
			Impacts: []
		});
	} catch (Error) {
		Cheat.Log('[RagebotFire] {0}\n'.format(Error), true);
	}
}

function DistanceToPosition(origin, destination) {
    const difference = [destination[0] - origin[0], destination[1] - origin[1], destination[2] - origin[2]];
    return Math.sqrt(difference[0] * difference[0] + difference[1] * difference[1] + difference[2] * difference[2]);
};

function ClosestPoint(Target, Source, Destination) {
	const To = [Target[0] - Source[0], Target[1] - Source[1], Target[2] - Source[2]];
	var Dir = [Destination[0] - Source[0], Destination[1] - Source[1], Destination[2] - Source[2]];

	const Length = Math.sqrt(Math.pow(Dir[0], 2) + Math.pow(Dir[1], 2) + Math.pow(Dir[2], 2));
	Dir = [Dir[0] / Length, Dir[1] / Length, Dir[2] / Length];

	const RangeAlong = Dir[0] * To[0] + Dir[1] * To[1] + Dir[2] * To[2];
	if (RangeAlong < 0.0) {
		return Source;
	}
	
    if (RangeAlong > Length) {
		return Destination;
	}

	return [Source[0] + Dir[0] * RangeAlong, Source[1] + Dir[1] * RangeAlong, Source[2] + Dir[2] * RangeAlong];
}

function CloseToLocalPlayer(Ent, Pos) {
    const EntityEyePosition = Entity.GetEyePosition(Ent);
    for (var i = 0; i < 5; i++) {
        const HitboxPos = Entity.GetHitboxPosition(Context.LocalPlayer.Index, i);
        const ClosePoint = ClosestPoint(HitboxPos, EntityEyePosition, Pos);
        const Distance = DistanceToPosition(ClosePoint, HitboxPos);
		const TraceResult = Trace.Line(Context.LocalPlayer.Index, Pos, HitboxPos);
        if (Distance > 30) {
			continue;
		}
		
		if (TraceResult[1] < 1.0) {
			continue;
		}

        return true;
    }

    return false;
};

function AntiBruteOnShot() {
	if (!ui.GetValue(AntiAimBuilder) || ui.GetValue(Refs.Script.AntiAim.AntiBruteType[StateOrGeneral(Context.AntiAim.State)]) != 1 || !ui.GetValue(Refs.Script.AntiAim.AntiBrute[StateOrGeneral(Context.AntiAim.State)]) || !Context.LocalPlayer.Alive) {
		return;
	}

	const Pos = [Event.GetFloat('x'), Event.GetFloat('y'), Event.GetFloat('z')];
	const UserId = Entity.GetEntityFromUserID(Event.GetInt('userid'));
	if (UserId == Context.LocalPlayer.Index || Context.AntiAim.Hitted || Entity.IsTeammate(UserId) || Entity.IsDormant(UserId)) {
		return;
	}

	if (!CloseToLocalPlayer(UserId, Pos)) {
		return;
	}

	ui.ToggleHotkey(Refs.AntiAim.Inverter);
	Context.AntiAim.AntiBrute = true;
	Context.AntiAim.AntiBruteTime = Context.Globals.Curtime;
}

function BulletImpact() {
	try {
		AntiBruteOnShot();
		if (Entity.GetEntityFromUserID(Event.GetInt('userid')) == Context.LocalPlayer.Index) {
			for (var i = Context.Rage.ShotData.length - 1; i >= 0; i--) {
				const Shot = Context.Rage.ShotData[i];
    	    	if (!Shot || Context.Globals.ServerTick - Shot.Tick > (2 / Context.Globals.TickInterval)) {
					Context.Rage.ShotData.splice(i, 1);
    	    	    continue;
    	    	}

    	    	Shot.HasBeenRegistered = true;
    	    	Shot.Impacts.push(Vector(Event.GetFloat('x'), Event.GetFloat('y'), Event.GetFloat('z')));
    		}

			if (ui.GetValue(VisualBulletTracer)) {
				Context.LineBulletTracerData.push({
					Impacts: Vector(Event.GetFloat("x"), Event.GetFloat("y"), Event.GetFloat("z")),
					Eye: Entity.GetEyePosition(Context.LocalPlayer.Index),
					Time: Context.Globals.Curtime,
				});
			}
		}
	} catch (Error) {
		Cheat.Log('[BulletImpact] {0}\n'.format(Error), true);
	}
}

function WeaponFire() {
	try {
		if (Entity.GetEntityFromUserID(Event.GetInt('userid')) != Context.LocalPlayer.Index) {
			return;
		}

		for (var i = Context.Rage.ShotData.length - 1; i >= 0; i--) {
			const Shot = Context.Rage.ShotData[i];
			if (!Shot || Context.Globals.ServerTick - Shot.Tick > (2 / Context.Globals.TickInterval)) {
				Context.Rage.ShotData.splice(i, 1);
				continue;
			}
			
			Shot.HasBeenFired = true;
		}

		if (ui.GetMultiDropdown(AntiAimTweaks, 0) && ui.GetValue(AntiAimBuilder)) {
			Context.AntiAim.ChokedTick = Context.LocalPlayer.ChokedCommands;
			Context.AntiAim.SilentTick = Context.Globals.Tickcount + Context.LocalPlayer.ChokedCommands;
			Context.AntiAim.Silent = true;
		}
		 
		if (ui.GetMultiDropdown(Refs.Script.AntiAim.Options[StateOrGeneral(Context.AntiAim.State)], 5) && ui.GetValue(AntiAimBuilder) && !Context.AntiAim.AntiBrute) {
			ui.ToggleHotkey(Refs.AntiAim.Inverter);
		}

		if (Context.LocalPlayer.Taser && ui.GetValue(MiscQuickSwitch)) {
			Context.ZeusFire = true;			
		} 

		Context.LocalPlayer.LastFire = Context.Globals.Curtime;
	} catch (Error) {
		Cheat.Log('[WeaponFire] {0}\n'.format(Error), true);
	}
}

function ItemPurchase() {
	try {
		BuyLogs();
	} catch (Error) {
		Cheat.Log('[ItemPurchase] {0}\n'.format(Error), true);
	}
}

function PlayerHurt() {
	try {
		if (Entity.GetEntityFromUserID(Event.GetInt('userid')) == Context.LocalPlayer.Index && Entity.GetEntityFromUserID(Event.GetInt('attacker')) != Context.LocalPlayer.Index) {
			Context.AntiAim.Hitted = true;
			Context.AntiAim.HittedTime = Context.Globals.Curtime;
		}

		HitLog();
		if (ui.GetValue(VisualKibitMarker)) {
			if (Entity.GetEntityFromUserID(Event.GetInt('userid')) != Context.LocalPlayer.Index && Entity.GetEntityFromUserID(Event.GetInt('attacker')) == Context.LocalPlayer.Index) {
				const Weapon = Event.GetString('weapon');

				if (Weapon == 'hegrenade' || Weapon == 'inferno' || Weapon == 'knife' || Weapon == 'smokegrenade' || Weapon == 'flashbang' || Weapon == 'decoy') {
					return;
				}

				Context.KibitWorldMarkerData.push({ Position: Entity.GetHitboxPosition(Entity.GetEntityFromUserID(Event.GetInt('userid')), HitgroupToHitbox(Event.GetInt('hitgroup'))), Time: Context.Globals.Curtime });
			}
		}

		if (ui.GetValue(VisualCrosshairHitmarker)) {
			if (Entity.GetEntityFromUserID(Event.GetInt('userid')) != Context.LocalPlayer.Index && Entity.GetEntityFromUserID(Event.GetInt('attacker')) == Context.LocalPlayer.Index) {
				Context.Crosshairhitmarker.ShouldDraw = true;
				Context.Crosshairhitmarker.Time = Context.Globals.Curtime;
			}
		}

		if (ui.GetValue(AntiAimBuilder) && ui.GetValue(Refs.Script.AntiAim.AntiBruteType[StateOrGeneral(Context.AntiAim.State)]) != 1 && ui.GetValue(Refs.Script.AntiAim.AntiBrute[StateOrGeneral(Context.AntiAim.State)])) {
			if (Entity.GetEntityFromUserID(Event.GetInt('userid')) != Context.LocalPlayer.Index && Entity.GetEntityFromUserID(Event.GetInt('attacker')) == Context.LocalPlayer.Index) {
				return;
			}

			ui.ToggleHotkey(Refs.AntiAim.Inverter);
			Context.AntiAim.AntiBrute = true;
			Context.AntiAim.AntiBruteTime = Context.Globals.Curtime;
		}
	} catch (Error) {
		Cheat.Log('[PlayerHurt] {0}\n'.format(Error), true);
	}
}

function CreateMove() {
	try {
		ui.SetValue(Refs.Rage.Doubletap, !(ui.GetValue(RagebotDTWithHSFix) && ui.GetHotkey(Refs.Rage.Doubletap) && ui.GetHotkey(Refs.Rage.Hideshots) && ui.GetValue(Refs.Rage.Hideshots) || ui.GetValue(RagebotDisableDTOnZeus) && Context.LocalPlayer.Taser));
		Context.Rage.CurrentWeapon = GetWeaponName();
		Context.Rage.CurrentTab	= GetTabName();
		Context.Rage.MinimumDamage = ui.GetValue(['Rage', Context.Rage.CurrentTab, 'Targeting', 'Minimum damage']);
		Context.Rage.MinimumHitchance = ui.GetValue(['Rage', Context.Rage.CurrentTab, 'Accuracy', 'Hitchance']);
		Context.Rage.ExploitCharge = Exploit.GetCharge();
		Context.Rage.Target	= Ragebot.GetTarget();
		Context.Rage.PredictedTarget = PredictTarget();
		Context.Rage.ClosestTarget = ClosestTarget();

		Context.Globals.ServerTime = Context.LocalPlayer.Netvars.Tickbase * Context.Globals.TickInterval;
		Context.LocalPlayer.Weapon.Index = Entity.GetWeapon(Context.LocalPlayer.Index);
		Context.LocalPlayer.Weapon.Name	= Entity.GetName(Context.LocalPlayer.Weapon.Index);
		Context.LocalPlayer.Weapon.ClassName = Entity.GetClassName(Context.LocalPlayer.Weapon.Index);

		Context.LocalPlayer.Netvars.Scoped = Entity.GetProp(Context.LocalPlayer.Index, 'DT_CSPlayer', 'm_bIsScoped');
		Context.LocalPlayer.Netvars.ResumeZoom = Entity.GetProp(Context.LocalPlayer.Index, 'CCSPlayer', 'm_bResumeZoom');
		Context.LocalPlayer.Netvars.Tickbase = Entity.GetProp(Context.LocalPlayer.Index, 'DT_CSPlayer', 'm_nTickBase');
		Context.LocalPlayer.Netvars.GroundEntity = Entity.GetProp(Context.LocalPlayer.Index, 'DT_BasePlayer', 'm_hGroundEntity');
		Context.LocalPlayer.Netvars.DuckAmount = Entity.GetProp(Context.LocalPlayer.Index, 'DT_BasePlayer', 'm_flDuckAmount');
		Context.LocalPlayer.Netvars.VecVelocity	= Vector(Entity.GetProp(Context.LocalPlayer.Index, 'DT_BasePlayer', 'm_vecVelocity[0]'));
		Context.LocalPlayer.Netvars.VecViewOffset = Vector(Entity.GetProp(Context.LocalPlayer.Index, 'DT_BasePlayer', 'm_vecViewOffset[0]'));
		Context.LocalPlayer.Netvars.EyeAngles = Vector(Entity.GetProp(Context.LocalPlayer.Index, 'DT_CSPlayer', 'm_angEyeAngles[0]'));
		Context.LocalPlayer.Netvars.VecOrigin = Vector(Entity.GetProp(Context.LocalPlayer.Index, 'DT_BasePlayer', 'm_vecOrigin'));
		Context.LocalPlayer.Netvars.NextAttack = Entity.GetProp(Context.LocalPlayer.Index, 'DT_BaseCombatCharacter', 'm_flNextAttack');
		Context.LocalPlayer.Netvars.Defusing = Entity.GetProp(Context.LocalPlayer.Index, 'DT_CSPlayer', 'm_bIsDefusing');
		Context.LocalPlayer.Netvars.Ping = Entity.GetProp(Context.LocalPlayer.Index, 'CPlayerResource', 'm_iPing');
		Context.LocalPlayer.Weapon.NextAttack = Entity.GetProp(Context.LocalPlayer.Weapon.Index, 'DT_BaseCombatWeapon', 'm_flNextPrimaryAttack');
		Context.LocalPlayer.Weapon.NonAim = Context.LocalPlayer.Weapon.ClassName == 'CKnife' || Context.LocalPlayer.Weapon.ClassName == 'CItem_Healthshot' || /grenade/gi.test(Context.LocalPlayer.Weapon.Name);
		Context.LocalPlayer.VelocityModifier = Entity.GetProp(Context.LocalPlayer.Index, "CCSPlayer", "m_flVelocityModifier");
		Context.LocalPlayer.Team = Entity.GetProp(Context.LocalPlayer.Index, 'DT_BaseEntity', 'm_iTeamNum');
		Context.LocalPlayer.CanFire	= Context.LocalPlayer.Alive && !Context.LocalPlayer.Weapon.NonAim && !Context.LocalPlayer.Netvars.Defusing && Context.LocalPlayer.Netvars.NextAttack < Context.Globals.ServerTime && Context.LocalPlayer.Weapon.NextAttack < Context.Globals.ServerTime;
		Context.LocalPlayer.Velocity = Context.LocalPlayer.Netvars.VecVelocity.Length();
		Context.LocalPlayer.Velocity2D = Context.LocalPlayer.Netvars.VecVelocity.Length2D();
		Context.LocalPlayer.Knife = Context.LocalPlayer.Weapon.ClassName == 'CKnife';
		Context.LocalPlayer.Grenade = Context.LocalPlayer.Weapon.ClassName == 'CFlashbang' || Context.LocalPlayer.Weapon.ClassName == 'CDecoyGrenade' || Context.LocalPlayer.Weapon.ClassName == 'CMolotovGrenade' || Context.LocalPlayer.Weapon.ClassName == 'CHEGrenade' || Context.LocalPlayer.Weapon.ClassName == 'CIncendiaryGrenade' || Context.LocalPlayer.Weapon.ClassName == 'CSmokeGrenade' || Context.LocalPlayer.Weapon.ClassName == 'CSensorGrenade';
		Context.LocalPlayer.Taser = Context.LocalPlayer.Weapon.ClassName == 'CWeaponTaser';
		Context.LocalPlayer.ChokedCommands = AddonFunctions.GetChokedCommands();
		Context.LocalPlayer.LastChokedCommands = Context.LocalPlayer.ChokedCommands;

		if (Context.LocalPlayer.ChokedCommands == 0) {
			Context.LocalPlayer.LagComp.LastKnownOrigin = Context.LocalPlayer.Netvars.VecOrigin;
		}

		if (Context.LocalPlayer.Netvars.VecOrigin.DistanceToSqr(Context.LocalPlayer.LagComp.LastKnownOrigin) > 4096) {
			Context.LocalPlayer.LagComp.LastBroken = Context.Globals.Tickcount;
			Context.LocalPlayer.LagComp.Ticks = Context.LocalPlayer.LastChokedCommands;
		}

		Context.LocalPlayer.LagComp.Broken = Context.LocalPlayer.LagComp.Ticks > 0 && Math.abs(Context.LocalPlayer.LagComp.LastBroken - Context.Globals.Tickcount) < Context.LocalPlayer.LagComp.Ticks;
		
		if (!Context.LocalPlayer.Netvars.GroundEntity) {
			Context.LocalPlayer.GroundTicks++;
		} else {
			Context.LocalPlayer.GroundTicks = 0;
		}

		Context.LocalPlayer.OnGround = Context.LocalPlayer.GroundTicks >= 2;

		if (Context.LocalPlayer.Weapon.Index) {
			Context.LocalPlayer.Netvars.NextPrimaryAttack = Entity.GetProp(Context.LocalPlayer.Weapon.Index, 'DT_BaseCombatWeapon', 'm_flNextPrimaryAttack');
		}

		if (Context.Addon.Loaded) {
			Context.LocalPlayer.Netvars.Ping = AddonFunctions.GetLatency('0') + AddonFunctions.GetLatency('1') * 1000;
		} 

		Context.LocalPlayer.EyePosition = Context.LocalPlayer.Netvars.VecOrigin.Copy().Add(Context.LocalPlayer.Netvars.VecViewOffset);

        Context.Players = Entity.GetPlayers();

		Context.Keybinds.Fakeduck = Context.Rage.ExploitCharge <= 0.5 && Context.LocalPlayer.OnGround && ui.GetValue(Refs.AntiAim.Enabled) && ui.GetHotkey(Refs.AntiAim.Fakeduck);
		Context.Keybinds.Doubletap = ui.GetValue(Refs.Rage.Doubletap) && ui.GetValue(Refs.Rage.Ragebot) && ui.GetHotkey(Refs.Rage.Doubletap);
		Context.Keybinds.Hideshots = ui.GetValue(Refs.Rage.Hideshots) && ui.GetValue(Refs.Rage.Ragebot)	&& ui.GetHotkey(Refs.Rage.Hideshots);
		Context.Keybinds.MinimumDamage = ui.GetValue(RagebotMinimumDamage) && ui.GetHotkey(Refs.Rage.Ragebot) && ui.GetValue(Refs.Rage.Ragebot) && ui.GetHotkey(Refs.Script.Rage.MinimumDamage);
		Context.Keybinds.HitchanceOverride = ui.GetValue(RagebotHitchanceOverride) && ui.GetHotkey(Refs.Rage.Ragebot) && ui.GetValue(Refs.Rage.Ragebot) && ui.GetHotkey(Refs.Script.Rage.Hitchance);
		Context.Keybinds.ForceBaim = ui.GetValue(Refs.Rage.Ragebot) && ui.GetHotkey(Refs.Rage.Ragebot) && ui.GetHotkey(Refs.Rage.ForceBaim);
		Context.Keybinds.ForceSafe = ui.GetValue(Refs.Rage.Ragebot) && ui.GetHotkey(Refs.Rage.Ragebot) && ui.GetHotkey(Refs.Rage.ForceSafe);
		Context.Keybinds.PingSpike = ui.GetHotkey(Refs.Script.Rage.PingSpike);
		Context.Keybinds.Autopeek = ui.GetValue(Refs.Misc.Autopeek)	&& ui.GetHotkey(Refs.Misc.Autopeek);
		Context.Keybinds.Slowwalk = ui.GetValue(Refs.AntiAim.Enabled) && ui.GetHotkey(Refs.AntiAim.Slowwalk);
		Context.Keybinds.Inverter = ui.GetValue(Refs.AntiAim.FakeAngles) && ui.GetValue(Refs.AntiAim.Enabled) && ui.GetHotkey(Refs.AntiAim.Inverter);
		Context.Keybinds.DormantAimbot = ui.GetHotkey(Refs.Script.Rage.DormantAimbot);
		Context.Keybinds.LegitAA = Input.IsKeyPressed(0x45) && StateOrGeneral(11) && ui.GetValue(AntiAimBuilder) && ShouldUseLegitAA();
		Context.Keybinds.Freestanding = ui.GetValue(Refs.AntiAim.Enabled) && ui.GetValue(AntiAimBuilder) && ui.GetHotkey(Refs.Script.AntiAim.Freestanding) && !Context.Keybinds.LegitAA && Context.AntiAim.ManualYaw <= 0;

		Context.AntiAim.State = GetAntiAimState();
		Context.AntiAim.Warmup = Entity.GetProp(Entity.GetGameRulesProxy(), 'CCSGameRulesProxy', 'm_bWarmupPeriod');
		Context.AntiAim.Freeze = Entity.GetProp(Entity.GetGameRulesProxy(), 'CCSGameRulesProxy', 'm_bFreezePeriod');

		Context.FakeLag.Enabled = ui.GetValue(Refs.Fakelag.Enabled);
		SilentOnShot();
		FreestandingOnKey();
		UpdateManualHotkeys();
		AABuilder();
		Autostrafer();
		QuickSwitch();
		FastRecharge();
		AntiPredict();
		DormantAimbot();
		AdaptiveAutoscope();
		JumpScout();
		HitchanceOverride();
		NoscopeHitchance();
		TwoShot();
		DamageOverride();
		ForceSafepointInLethal();
	} catch (Error) {
		Cheat.Log('[CreateMove] {0}\n'.format(Error), true);
	}
}

function Draw() {
	try {
		Context.Addon.Loaded = AddonFunctions.CanUseAddonFunctions();

		Context.Globals.FixedRealtime += Context.Globals.Frametime;
		Context.Globals.Curtime	= Globals.Curtime();
		Context.Globals.Framerate = Math.round(1 / Context.Globals.Frametime);
		Context.Globals.Frametime = Globals.Frametime();
		Context.Globals.Realtime = Globals.Realtime();
		Context.Globals.TickInterval = Globals.TickInterval();
		Context.Globals.Tickcount = Globals.Tickcount();
		Context.Globals.Tickrate = Globals.Tickrate();
		Context.Globals.ServerTick = Math.round(Context.Globals.Tickcount + Local.Latency() / Context.Globals.TickInterval);
		
		Context.LocalPlayer.Index = Entity.GetLocalPlayer();
		Context.LocalPlayer.Alive = Entity.IsAlive(Context.LocalPlayer.Index);
		Context.LocalPlayer.Money = Entity.GetProp(Context.LocalPlayer.Index, "CCSPlayer", "m_iAccount");
		if (!Context.LocalPlayer.Alive) {
			Context.LocalPlayer.Netvars.Tickbase = Entity.GetProp(Context.LocalPlayer.Index, 'DT_CSPlayer', 'm_nTickBase');
			Context.Globals.ServerTime = Context.LocalPlayer.Netvars.Tickbase * Context.Globals.TickInterval;
		}

		Context.Colors.MainLogColor = [159, 202, 43];
		Context.Colors.MainAltLogColor = [255, 0, 50];
		if (ui.GetValue(MiscCustomColorLogs)) {
			Context.Colors.MainLogColor = ui.GetColor(Refs.Script.Visual.MainLogColor);
			Context.Colors.MainAltLogColor = ui.GetColor(Refs.Script.Visual.MainAltLogColor);
		} 

		Context.Colors.MainColor = ui.GetColor(Refs.Script.Visual.MainColor);
		Context.Colors.BulletTracer = ui.GetColor(Refs.Script.Visual.BulletTracerColor);
		Context.Colors.AlternativeColor = ui.GetColor(Refs.Script.Visual.AlternativeColor);
		Context.Colors.DMGColor = ui.GetColor(Refs.Script.Visual.DMGIndicatorColor);
		Context.Colors.DMGActiveColor = ui.GetColor(Refs.Script.Visual.DMGActiveIndicatorColor);
		Context.Colors.CrosshairColor = ui.GetColor(Refs.Script.Visual.CrosshairHitmarkerColor);
		Context.Colors.MainKibit = ui.GetColor(Refs.Script.Visual.MainKibitColor);
		Context.Colors.AltKibit	= ui.GetColor(Refs.Script.Visual.AltKibitColor);

		Context.Fonts.Calibri = Render.AddFont('Calibri', 18, 600);
		Context.Fonts.VerdanaBold = Render.AddFont('Verdana', 7, 600);
		Context.Fonts.VerdanaBold1 = Render.AddFont('Verdana', 7, 600);
		Context.Fonts.VerdanaBold2 = Render.AddFont('Verdana Bold', 15, 600);
		Context.Fonts.Verdana = Render.AddFont('Verdana', 7, 100);
		Context.Fonts.VerdanaThin = Render.AddFont('Verdana', 7, 500);
		Context.Fonts.SmallPixel = Render.AddFont('Small Fonts', 5, 400);
		if (ui.GetValue(VisualOptimize) && Render.GetScreenSize()[0] >= 1921 && Render.GetScreenSize()[1] >= 1440) {
			Context.Fonts.VerdanaBold = Render.AddFont('Verdana', 8, 600);
			Context.Fonts.VerdanaThin = Render.AddFont('Verdana', 8, 500);
			Context.Fonts.SmallPixel = Render.AddFont('Small Fonts', 6, 900);
		}

		Context.Animations.Scoped.Update(Context.LocalPlayer.Netvars.Scoped || Context.LocalPlayer.Netvars.ResumeZoom);
		Context.Animations.Doubletap.Update(Context.Keybinds.Doubletap && !Context.Keybinds.Fakeduck);
		Context.Animations.Hideshots.Update(Context.Keybinds.Hideshots && !Context.Keybinds.Fakeduck);
		Context.Animations.MinimumDamage.Update(Context.Keybinds.MinimumDamage);
		Context.Animations.ForceBaim.Update(Context.Keybinds.ForceBaim);
		Context.Animations.ForceSafe.Update(Context.Keybinds.ForceSafe);
		Context.Animations.PingSpike.Update(Context.Keybinds.PingSpike);
		Context.Animations.Freestanding.Update(Context.Keybinds.Freestanding);
		Context.Animations.DormantAimbot.Update(Context.Keybinds.DormantAimbot);
		Context.Animations.Hitchance.Update(Context.Keybinds.HitchanceOverride);
		Context.Animations.Exploiting.Update(Context.LocalPlayer.CanFire && Context.Rage.ExploitCharge == 1);
		Context.Animations.Dormant.Update(Context.Rage.ClosestTarget && Entity.IsDormant(Context.Rage.ClosestTarget));
		Context.Animations.FakeDuck.Update(Context.Keybinds.Fakeduck);
		Context.Animations.LagComp.Update(Context.LocalPlayer.LagComp.Broken && !Context.LocalPlayer.OnGround);
		Context.Animations.Freeze.Update(Context.AntiAim.Freeze);
		Context.Animations.Hitted.Update(Context.AntiAim.Hitted);
		Context.Animations.NotFreeze.Update(!Context.AntiAim.Freeze);
		Context.Animations.NotGrenade.Update(!Context.LocalPlayer.Grenade);
		Context.Animations.VelocityModifier.Update(Context.LocalPlayer.VelocityModifier < 1);
		Context.Animations.AntiBrute.Update(Context.AntiAim.AntiBrute);
		Context.Animations.SafeHead.Update(Context.AntiAim.SafeHead);
		Context.Animations.PingColor = Lerp(Context.Animations.PingColor, Clamp(Context.LocalPlayer.Netvars.Ping / 160, 0, 1), 0.8);

		if (!World.GetServerString() || !Context.LocalPlayer.Alive) {
			Context.AntiAim.Silent = false;
		}

		if (Math.abs(Context.AntiAim.HittedTime - Context.Globals.Curtime) >= 2 || !Context.LocalPlayer.Alive) {
			Context.AntiAim.Hitted = false;
		}

		if (Math.abs(Context.AntiAim.AntiBruteTime - Context.Globals.Curtime) >= 2 || !Context.LocalPlayer.Alive) {
			Context.AntiAim.AntiBrute = false;
		}
		
		ui.Update();
		const LabelBackup = Context.Label;
		const BuildBackup = Context.Build;
		if (ui.GetValue(ZV)) {
			Context.Label = 'ZoV';
			Context.Build = 'YAW';
		}

		if (Context.LocalPlayer.Alive) {
			KeepScopeTransparancy();
			TransparencyGrenade();
			RevolverHelper();
			DmgIndicator();
			ManualArrows();
			
			switch (ui.GetValue(VisualIndicators)) {
				case 1: IndicatorsType1(); break;
				case 2: IndicatorsType2(); break;
				case 3: IndicatorsType3(); break;
			}
		}	
		
		switch (ui.GetValue(VisualSkeetIndicators)) {
			case 1: SkeetIndicators(); break;
			case 2: AnimatedSkeetIndicators(); break;
		}

		PingSpike();
		SmartBuyBot();
		Trashtalk();
		Clantag();
		HandleImportExport();
		KibitWorldMarker();
		LineBulletTracer();
		CrosshairHitmarker();
		Watermark();
		UpdateSpectators();
		FivehundredDollarsSpectators();
		AspectRatio();
		Thirdperson();
		EventLog();
		CrosshairLog();
		Context.Build = BuildBackup;
		Context.Label = LabelBackup;
	} catch (Error) {
		Cheat.Log('[Draw] {0}\n'.format(Error), true);
	}
}

function FrameStageNotify() {
	try {
		if (Cheat.FrameStage() == 1) {
			MusicKit();
		}

		if (Cheat.FrameStage() == 4) {
			MissLog();
		}
	} catch (Error) {
		Cheat.Log('[FSN] {0}\n'.format(Error), true);
	}
}

function GrenadeThrown() {
	try{
		if (Context.LocalPlayer.Index != Entity.GetEntityFromUserID(Event.GetInt('userid'))) {
			return;
		}

		if (ui.GetMultiDropdown(AntiAimTweaks, 0) && ui.GetValue(AntiAimBuilder)) {
			Context.AntiAim.SilentTick = Context.Globals.Tickcount + ui.GetValue(Refs.Fakelag.TriggerLimit);
			Context.AntiAim.Silent = true;
		}

		Context.GrenadeThrown = true;
	} catch(Error) {
		Cheat.Log('[GrenadeThrown] {0}\n'.format(Error), true);
	}
}

function PlayerDeath() {
	try {
		if (Entity.GetEntityFromUserID(Event.GetInt('userid')) == Context.LocalPlayer.Index || Entity.GetEntityFromUserID(Event.GetInt('attacker')) != Context.LocalPlayer.Index) {
			return;
		}

		while (Context.LastPhrases.length > 10) {
			Context.LastPhrases.splice(0, 1);
		}

		var Index = Math.floor(Math.random() * Kill.length);

		while (Context.LastPhrases.indexOf(Index) != -1) {
			Index = Math.floor(Math.random() * Kill.length);
		}

		Context.LastPhrases.push(Index);

		for (var i = 0; i < Kill[Index].length; i++) {
			const Phrase = Kill[Index][i];
			if (!Phrase || !Phrase.Text) {
				continue;
			}

			Context.TrashtalkQueue.push({
				Text: Phrase.Text.replace(/�/gi, ''),
				Time: Context.Globals.Curtime + 2 + Phrase.Delay + Math.random() * 0.20,
			})
		}
	} catch(Error) {
		Cheat.Log('[PlayerDeath] {0}\n'.format(Error), true);
	}
}

function Unload() {
	Exploit.EnableRecharge();
	Cheat.ExecuteCommand('-attack');
	Entity.SetProp(Context.LocalPlayer.Index, "CCSPlayerResource", "m_nMusicID", 0);
	UI.SetEnabled('Visual', 'WORLD', 'View', 'Thirdperson', true);
	UI.SetEnabled('Misc', 'GENERAL', 'Movement', 'Turn speed', true);

	if (!Context.Visuals.KeepScopeTransparancyRestored) {
		ui.SetValue(Refs.Visual.VisibleTransparency, Context.Visuals.VisibleTransparencyRestored)
	}

	if (!Context.Visuals.TransparencyGrenadeRestored) {
		ui.SetValue(Refs.Visual.VisibleTransparency, Context.Visuals.VisibleTransparencyRestored)
	}

	if (!Context.Clantag.Restored) {
		Local.SetClanTag('');
	}

	if (!Context.LocalPlayer.RestoredBuy) {
		ui.SetValue(Refs.Misc.BuyBot, 0);
	}

	if (!Context.AntiAim.RestoredOverride) {
		AntiAim.SetOverride(0);
	}

	if (!Context.AntiAim.RestoredSilent) {
		ui.SetValue(Refs.Fakelag.Enabled, Context.FakeLag.Backup);
	}

	if (!Context.Misc.RestoredAspectratio) {
		Convar.SetFloat('r_aspectratio', Context.Misc.BackupedAspectratio);
	}

	if (!Context.Misc.RestoredThirdperson) {
		ui.SetValue(Refs.Visual.Thirdperson, Context.Misc.BackupedThirdperson);
	}
}

Cheat.RegisterCallback('CreateMove', 'CreateMove');
Cheat.RegisterCallback('Draw', 'Draw');
Cheat.RegisterCallback('player_death', 'PlayerDeath');
Cheat.RegisterCallback('grenade_thrown', 'GrenadeThrown');
Cheat.RegisterCallback('player_say', 'Chat');
Cheat.RegisterCallback('ragebot_fire', 'RagebotFire');
Cheat.RegisterCallback('player_hurt', 'PlayerHurt');
Cheat.RegisterCallback('bullet_impact', 'BulletImpact');
Cheat.RegisterCallback('item_purchase', 'ItemPurchase');
Cheat.RegisterCallback('weapon_fire', 'WeaponFire');
Cheat.RegisterCallback('FrameStageNotify', 'FrameStageNotify');
Cheat.RegisterCallback('Unload', 'Unload');
Cheat.Log('Welcome, {0}!\n'.format(Context.Username));
Cheat.Log('version: {0} [{1}]\n'.format(Context.Version, Context.Build.toLowerCase()));
Cheat.Log('dsc.gg/cynosatech\n');
Cheat.Log('dsc.gg/nexushvh\n');
Cheat.ExecuteCommand("@panorama_disable_blur 1");
Cheat.ExecuteCommand("cl_threaded_init 1");
Cheat.ExecuteCommand("mat_queue_mode 2");
Cheat.ExecuteCommand("cl_threaded_bone_setup 1");